/* Copyright 2012-2013 Yorba Foundation
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

private class Geary.ImapEngine.ReplayDisconnect : Geary.ImapEngine.ReceiveReplayOperation {
    public GenericFolder owner;
    public Imap.ClientSession.DisconnectReason reason;
    
    public ReplayDisconnect(GenericFolder owner, Imap.ClientSession.DisconnectReason reason) {
        base ("Disconnect");
        
        this.owner = owner;
        this.reason = reason;
    }
    
    public override void notify_remote_removed_position(Imap.SequenceNumber removed) {
    }
    
    public override void notify_remote_removed_ids(Gee.Collection<ImapDB.EmailIdentifier> ids) {
    }
    
    public override void get_ids_to_be_remote_removed(Gee.Collection<ImapDB.EmailIdentifier> ids) {
    }
    
    public override async ReplayOperation.Status replay_local_async() throws Error {
        debug("%s ReplayDisconnect reason=%s", owner.to_string(), reason.to_string());
        
        Geary.Folder.CloseReason remote_reason = reason.is_error()
            ? Geary.Folder.CloseReason.REMOTE_ERROR : Geary.Folder.CloseReason.REMOTE_CLOSE;
        
        // because close_internal_async() may schedule a ReplayOperation before its first yield,
        // that means a ReplayOperation is scheduling a ReplayOperation, which isn't something
        // we want to encourage, so use the Idle queue to schedule close_internal_async
        Idle.add(() => {
            owner.close_internal_async.begin(Geary.Folder.CloseReason.LOCAL_CLOSE, remote_reason, null);
            
            return false;
        });
        
        return ReplayOperation.Status.COMPLETED;
    }
    
    public override string describe_state() {
        return "reason=%s".printf(reason.to_string());
    }
}

