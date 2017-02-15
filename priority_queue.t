#!/usr/local/bin/perl

use PriorityQueue;
use Test::More tests => 12;

use_ok('PriorityQueue', 'Module exists');

 # Testing IsEmpty_Test
my $queue = PriorityQueue->new();
ok($queue->IsEmpty() == 1, "IsEmpty returns true");
$queue->Insert(5);
ok($queue->IsEmpty() != 1, "IsEmpty returns false");

 # Testing GetNext
$queue->Insert(3);
$queue->Insert(4);
ok($queue->GetNext() == 3, "GetNext on a non-empty queue");
$queue->GetNext();
$queue->GetNext();
ok($queue->GetNext() eq '', "GetNext on an empty queue");
ok($queue->{count} == 0, "Check Dead end");

 # Testing Exchange
$queue->Insert(10);
$queue->Insert(5);
$queue->Insert(15);
$queue->_Exchange({FIRST => 1, SECOND => 2});
is_deeply($queue->{queue}, ['DEADEND',10,5,15], "Exchange check");

$queue = PriorityQueue->new();
$queue->Insert(3);
$queue->Insert(5);
$queue->Insert(5);

 # Testing Compare
ok($queue->_CompareTo({FIRST => 1, SECOND => 3}) == -1, "Less than");
ok($queue->_CompareTo({FIRST => 3, SECOND => 1}) == 1, "Greater than");
ok($queue->_CompareTo({FIRST => 2, SECOND => 3}) == 0, "Equal to");

 # Testing the entire DS
$queue->Insert(10);
$queue->Insert(15);
$queue->Insert(6);
$queue->Insert(3);

is_deeply($queue->{queue}, ["DEADEND", 3, 5, 3, 10, 15, 6, 5], "Array contents after 7 inserts");

my @queuedtasks;
for my $val(1..$queue->{count}){
	push(@queuedtasks,$queue->GetNext());
}

is_deeply(\@queuedtasks, [3,3,5,5,6,10,15], "Queue result");

