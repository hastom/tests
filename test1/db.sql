/*
 индекс по category для фильтрации по категории
 primary для инкремента и сортировки
*/
CREATE TABLE `posts` (
    id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    category ENUM('CAT1','CAT2', 'CAT3'),
    content VARCHAR(242),
    PRIMARY KEY (`id`),
    KEY `category` (`category`)
) ENGINE=InnoDB

/*
 индекс по post_id для выборки лайкнувших по посту, если нужна выборка лайкнутых постов, такой же индекс для user_id
 primary для реализации many2many связи
*/

CREATE TABLE `likes` (
    `post_id` INT(11) UNSIGNED NOT NULL,
    `user_id` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`post_id`,`user_id`),
    KEY `post_id` (`post_id`)
) ENGINE=InnoDB;

CREATE TABLE `users` (
    id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
)

-- лайкнуть
INSERT INTO `likes` SET `post_id` = ?, `user_id` = ?;

-- снять лайк
DELETE FROM `likes` WHERE `post_id` = ? AND `user_id` = ?;

-- показать тех кто поставил лайк c пагинацией, параметром для id будет последний id на предыдущей странице
SELECT * FROM `users` WHERE EXISTS (SELECT 1 FROM `likes` WHERE `likes`.`user_id` = `users`.`id` AND `likes`.`post_id` = ?) AND `id` > ? ORDER BY `id` LIMIT 10;

-- добавить пост
INSERT INTO `posts` SET `category` = ?, `content` = ?;

-- отредактировать пост
UPDATE `posts` SET `category` = ?, `content` = ? WHERE `id` = ?;

-- получить список постов фильтрованный по категории
SELECT * FROM `posts` WHERE `category` = ? ORDER BY `id` DESC;
