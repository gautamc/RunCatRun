use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'RunCatRun' }
BEGIN { use_ok 'RunCatRun::Controller::Search' }

ok( request('/search')->is_success, 'Request should succeed' );
done_testing();
