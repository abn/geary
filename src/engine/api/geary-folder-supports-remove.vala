/* Copyright 2012-2013 Yorba Foundation
 *
 * This software is licensed under the GNU Lesser General Public License
 * (version 2.1 or later).  See the COPYING file in this distribution.
 */

/**
 * The addition of the Geary.FolderSupport.Remove interface to a {@link Geary.Folder}
 * indicates that it supports removing (deleting) email.
 *
 * This generally means that the message is deleted from the server and is not recoverable.
 * It _may_ mean the message is moved to a Trash folder where it may or may not be
 * automatically deleted some time later; this behavior is server-specific and not always
 * determinable by Geary (or worked around, either).
 *
 * The remove operation is distinct from the archive operation, available via
 * {@link Geary.FolderSupport.Archive}.
 *
 * A Folder that does not support Remove does not imply that email might not be removed later,
 * such as by the server.
 */
public interface Geary.FolderSupport.Remove : Geary.Folder {
    /**
     * Removes the specified emails from the folder.
     *
     * The {@link Geary.Folder} must be opened prior to attempting this operation.
     */
    public abstract async void remove_email_async(Gee.List<Geary.EmailIdentifier> email_ids,
        Cancellable? cancellable = null) throws Error;
    
    /**
     * Removes one email from the folder.
     *
     * The {@link Geary.Folder} must be opened prior to attempting this operation.
     */
    public virtual async void remove_single_email_async(Geary.EmailIdentifier email_id,
        Cancellable? cancellable = null) throws Error {
        Gee.ArrayList<Geary.EmailIdentifier> ids = new Gee.ArrayList<Geary.EmailIdentifier>();
        ids.add(email_id);
        
        yield remove_email_async(ids, cancellable);
    }
}

