use v6;
use Test;

plan 12;

#?rakudo.parrot skip 'NYI'
{
    my $c = Channel.new;
    $c.send(1);
    $c.send(2);
    is $c.peek, 1, "Peeked first value";
    is $c.receive, 1, "Received first value";
    is $c.poll, 2, "Polled for second value";
    ok $c.peek === Nil, "peek returns Nil when no values available";
    ok $c.poll === Nil, "poll returns Nil when no values available";
}

#?rakudo.parrot skip 'NYI'
{
    my $c = Channel.new;
    $c.send(42);
    $c.close();
    nok $c.closed, "Channel not closed before value received";
    is $c.receive, 42, "Received value";
    ok $c.closed, "Channel closed after all values received";
    dies_ok { $c.receive }, "Receiving from closed channel throws";
}

#?rakudo.parrot skip 'NYI'
{
    my $c = Channel.new;
    $c.send(1);
    $c.fail("oh noes");
    is $c.receive, 1, "received first value";
    dies_ok { $c.receive }, "error thrown on receive";
    is $c.closed.cause.message, "oh noes", "failure reason conveyed";
}
