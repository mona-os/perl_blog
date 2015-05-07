use strict;
use warnings;
use Test::More;


use Catalyst::Test 'alexBlog';
use alexBlog::Controller::Login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
