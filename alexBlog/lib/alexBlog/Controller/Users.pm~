package alexBlog::Controller::Users;
use Moose;
use namespace::autoclean;
use Digest::MD5;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

alexBlog::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched alexBlog::Controller::Users in Users.');
}



=encoding utf8

=head1 AUTHOR

mona,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 list
Fetch all users and pass to the view in
stash to be displayed
=cut

sub base :Chained('/') :PathPart('users'):CaptureArgs(0) {
my ($self, $c) = @_;
# Store the ResultSet in stash so it's available for other methods
$c->stash(resultset => $c->model('DB::User'));
# Print a message to the debug log
$c->log->debug('*** INSIDE BASE METHOD ***');
}
=head2 form_new
Display form to add data
=cut
sub form_new :Chained('base'):PathPart('new')  {
my ($self, $c) = @_;
# Set the TT template to use
$c->stash(template => 'users/new.tt');
}

=head2 form_create
Take information from form and add to database
=cut
sub form_create :Chained('base') :PathPart('create') :Args(0) {
my ($self, $c) = @_;
# Retrieve the values from the form
my $name = $c->request->params->{name} || 'N/A';
my $email = $c->request->params->{email} || 'N/A';
my $password= $c->request->params->{password} || 'N/A';
# Create the user
my $user = $c->model('DB::User')->create({name => $name,email => $email,password => $password
});
# Store new model object in stash and set template
$c->stash(user => $user,template => 'users/list.tt');
$c->response->redirect($c->uri_for($self->action_for('list')));
}

=head2 object
    
    Fetch the specified book object based on the book ID and store
    it in the stash
    
=cut
    
    sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
        # $id = primary key of user to delete
        my ($self, $c, $id) = @_;
    
        # Find the user object and store it in the stash
        $c->stash(object => $c->stash->{resultset}->find($id));
    
        # Make sure the lookup was successful.  You would probably
        # want to do something like this in a real app:
         $c->detach('/error_404') if !$c->stash->{object};
         die "user $id not found!" if !$c->stash->{object};
    
        # Print a message to the debug log
        $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
    }


sub show :Chained('object') :PathPart('show') :Args(0) {
my ($self, $c) = @_;
$c->stash(user =>$c->stash->{object});
$c->stash(template => 'users/show.tt');
}

sub edit :Chained('object') :PathPart('edit') :Args(0) {
my ($self, $c) = @_;
$c->stash(user =>$c->stash->{object});
$c->stash(template => 'users/edit.tt');
}


=head2 delete
    
    Delete a user
=cut
    
sub delete :Chained('object') :PathPart('delete') :Args(0) {
        my ($self, $c) = @_;
    
        # Use the book object saved by 'object' and delete it along
        # with related 'book_author' entries
        $c->stash->{object}->delete;
    
        # Set a status message to be displayed at the top of the view
        $c->stash->{status_msg} = "user deleted.";
    
        # Forward to the list action/method in this controller
        $c->forward('list');
    }

sub update :Chained('object') :PathPart('update') :Args(0) {
        my ($self, $c) = @_;
    
       my $name = $c->request->params->{name} || 'N/A';
       my $email = $c->request->params->{email} || 'N/A';
       my $password= $c->request->params->{password} || 'N/A';
       my $user= $c->stash->{object}->update({name => $name,email => $email,password => Digest::MD5::md5_hex($password)}
                                    );
 
        # Forward to the list action/method in this controller
        $c->forward('list');
    }


sub list :Local {
my ($self, $c) = @_;
$c->stash(users => [$c->model('DB::User')->all]);
$c->stash(template => 'users/list.tt');
}

sub form_login :Local  {
my ($self, $c) = @_;
# Set the TT template to use
$c->stash(template => 'users/login.tt');
}

 sub login :Local {
        my ($self, $c) = @_;
    
        # Get the username and password from form
        my $username = $c->request->params->{name};
        my $password = $c->request->params->{password};
    
        # If the username and password values were found in form
        if ($username && $password) {
            # Attempt to log the user in
            if ($c->authenticate({ name => $username,
                                   password => $password  } )) {
                # If successful, then let them use the application
                $c->response->redirect($c->uri_for(
                    $c->controller('Users')->action_for('list')));
                return;
            } else {
                # Set an error message
                $c->stash(error_msg => "Bad username or password.");
            }
        } else {
            # Set an error message
            $c->stash(error_msg => "Empty username or password.")
                unless ($c->user_exists);
        }
    
        # If either of above don't work out, send to the login page
        $c->stash(template => 'users/login.tt');
    }

=head2 logout
    
    Logout logic
    
=cut
    
sub logout :Local {
        my ($self, $c) = @_;
    
        # Clear the user's state
        $c->logout;
    
        # Send the user to the starting point
        $c->response->redirect($c->uri_for('form_login'));
    }

__PACKAGE__->meta->make_immutable;

1;
