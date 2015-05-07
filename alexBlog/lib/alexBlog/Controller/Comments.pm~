package alexBlog::Controller::Comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

alexBlog::Controller::Comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched alexBlog::Controller::Comments in Comments.');

}
sub base :Chained('/') :PathPart('users'):CaptureArgs(0) {
my ($self, $c) = @_;
# Store the ResultSet in stash so it's available for other methods
$c->stash(resultset => $c->model('DBComments::User'));
# Print a message to the debug log
$c->log->debug('*** INSIDE BASE METHOD ***');
}
sub add_comment :Chained('object') :PathPart('addComment') :Args(1) {
        my ($self, $c) = @_;
    

       my $body = $c->request->params->{body} || 'N/A';
       my $user_id= $c->request->params->{user_id} || 'N/A';
       my $post_id= $c->request->params->{post_id} || 'N/A';
       my $comment = $c->model('DBComments::Comment')->create({body => $body,user_id => $user_id,post_id => $post_id});
# Store new model object in stash and set template
#$c->stash(post => $post,template => 'posts/show.tt');

    }
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
sub list :Local {
my ($self, $c) = @_;
$c->stash(users => [$c->model('DB::User')->all]);
$c->stash(template => 'users/list.tt');
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
