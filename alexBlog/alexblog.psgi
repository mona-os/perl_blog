use strict;
use warnings;

use alexBlog;

my $app = alexBlog->apply_default_middlewares(alexBlog->psgi_app);
$app;

