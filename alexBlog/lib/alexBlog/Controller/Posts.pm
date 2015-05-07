package alexBlog::Controller::Posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

alexBlog::Controller::Posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched alexBlog::Controller::Posts in Posts.');
}

sub base :Chained('/') :PathPart('posts'):CaptureArgs(0) {
my ($self, $c) = @_;
# Store the ResultSet in stash so it's available for other methods
$c->stash(resultset => $c->model('DBPosts::Post'));

# Print a message to the debug log
$c->log->debug('*** INSIDE BASE METHOD ***');
}

sub form_new :Chained('base'):PathPart('new')  {
my ($self, $c) = @_;
# Set the TT template to use
$c->stash(template => 'posts/new.tt');
}

sub form_create :Chained('base') :PathPart('create') :Args(0) {
my ($self, $c) = @_;
# Retrieve the values from the form
my $title = $c->request->params->{title} || 'N/A';
my $body = $c->request->params->{body} || 'N/A';
my $user_id= $c->request->params->{user_id} || 'N/A';
# Create the userP
my $post = $c->model('DBPosts::Post')->create({title => $title,body => $body,user_id => $user_id});
# Store new model object in stash and set template
$c->stash(post => $post,template => 'posts/list.tt');
$c->response->redirect($c->uri_for($self->action_for('list')));
}
 

 sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
        # $id = primary key of user to delete
        my ($self, $c, $id) = @_;
    
        # Find the user object and store it in the stash
        $c->stash(object => $c->stash->{resultset}->find($id));
    
        # Make sure the lookup was successful.  You would probably
        # want to do something like this in a real app:
         $c->detach('/error_404') if !$c->stash->{object};
         die "post $id not found!" if !$c->stash->{object};
    
        # Print a message to the debug log
        $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
    }


sub show :Chained('object') :PathPart('show') :Args(0) {
my ($self, $c) = @_;
#$c->stash(post =>$c->stash->{object});
my $id = $c->stash->{object}->id ; 
$c->stash(comments=> [$c->model('DBComments::Comment')->search({post_id => $id})]);
$c->stash(post =>$c->stash->{object});
$c->stash(template => 'posts/show.tt');
}

sub edit :Chained('object') :PathPart('edit') :Args(0) {
my ($self, $c) = @_;
$c->stash(post =>$c->stash->{object});
$c->stash(template => 'posts/edit.tt');
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
        $c->stash->{status_msg} = "post deleted.";
    
        # Forward to the list action/method in this controller
        $c->forward('list');
    }

sub update :Chained('object') :PathPart('update') :Args(0) {
        my ($self, $c) = @_;
    
       my $title = $c->request->params->{title} || 'N/A';
       my $body = $c->request->params->{body} || 'N/A';
       my $user_id= $c->request->params->{user_id} || 'N/A';
       my $user= $c->stash->{object}->update({title => $title,body => $body,user_id  => $user_id });
 
        # Forward to the list action/method in this controller
        $c->forward('list');
    }
 
        

sub delete_comment :Chained('object') :PathPart('deleteComment') :Args(0) {
       my ($self, $c,$cid) = @_;


my $cid= $c->request->params->{id};
$c->log->debug($cid);
my $id = $c->stash->{object}->id ;
$c->log->debug($id);
# Create the user
my $comment = $c->model('DBPosts::Comment')->find( $cid);
$comment->delete;

# Store new model object in stash and set template
$c->response->redirect($c->uri_for($self->action_for('show'),[$id]));
#$c->stash(user => $user,template => 'users/show.tt');
    }


sub list :Local {
my ($self, $c) = @_;
$c->stash(posts => [$c->model('DBPosts::Post')->all]);
$c->stash(template => 'posts/list.tt');
}

sub add_comment :Chained('object') :PathPart('addComment') :Args(0) {
        my ($self, $c) = @_;

       my $id = $c->stash->{object}->id ; 
       my $body = $c->request->params->{body} || 'N/A';
       my $user_id= $c->request->params->{user_id} ;

       my $comment = $c->model('DBPosts::Comment')->create({body => $body,user_id =>$user_id, post_id => $id});
       $c->response->redirect($c->uri_for($self->action_for('show'),[$id])); 


    }
 

=encoding utf8

=head1 AUTHOR

mona,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
