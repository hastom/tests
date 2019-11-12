<?php

$db_host = 'localhost';
$db_port = 3306;
$db_name = 'test';
$db_user = 'test';
$db_pass = 'test';
$dsn = 'mysql:host=' . $db_host . ';port=' . $db_port . ';dbname=' . $db_name . '';
$chunk_size = 10000;
$last_id = 0;
$counters = [];

$dbh = new PDO($dsn, $db_user, $db_pass);
/*
 * если пустые email'ы составляют значительную часть данных то отфильтруем при создании, иначе можно отфильтровать на скрипте
 * PRIMARY KEY делается, чтобы разбивать запросы на куски не с помощью LIMIT, что очень не эффективно при больших OFFSET
 */
$dbh->exec('CREATE TEMPORARY TABLE `emails` (PRIMARY KEY (`id`)) AS (SELECT `id`, `email` FROM `users` WHERE `email` != \'\')');

while ($rows = $dbh->query('SELECT * FROM `emails`  WHERE `id` > ' . $last_id . '  ORDER BY `id` LIMIT ' . $chunk_size)->fetchAll(PDO::FETCH_OBJ)) {
	foreach ($rows as $row) {
		$emails = explode(',', $row->email);
		foreach ($emails as $email) {
			$domain = substr(strrchr($email, "@"), 1);
			$counters[$domain] = $counters[$domain] ?? 0;
			$counters[$domain]++;
		}
		$last_id = $row->id;
	}
}

print_r($counters);
