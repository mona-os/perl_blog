package alexBlog::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

alexBlog::View::HTML - TT View for alexBlog

=head1 DESCRIPTION

TT View for alexBlog.

=head1 SEE ALSO

L<alexBlog>

=head1 AUTHOR

mona,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
