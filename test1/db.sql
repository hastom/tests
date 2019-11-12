CREATE TABLE `posts` (
    id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    category ENUM('CAT1','CAT2', 'CAT3'), -- или если список категорий динамический то в зависимости от кол-ва TINYINT / INT
    content VARCHAR(242),
    PRIMARY KEY (`id`),
    KEY `category` (`category`) -- для фильтрации по категории
) ENGINE=InnoDB

CREATE TABLE `likes` (
    `post_id` INT(11) UNSIGNED NOT NULL,
    `user_id` INT(11) UNSIGNED NOT NULL,
    PRIMARY KEY (`post_id`,`user_id`),
    KEY `post_id` (`post_id`) -- для выборки лайкнувших по посту, если нужна выборка лайкнутых постов, такой же индекс для user_id
) ENGINE=InnoDB;

CREATE TABLE `users` (
    id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
)

-- лайкнуть
INSERT INTO `likes` SET `post_id` = ?, `user_id` = ?;

-- снять лайк
DELETE FROM `likes` WHERE `post_id` = ? AND `user_id` = ?;

-- показать тех кто поставил лайк
SELECT `users`.* WHERE EXISTS (SELECT 1 FROM `likes` WHERE `likes`.`user_id` = `users`.`id` AND `likes`.`post_id` = ?);

-- добавить пост
INSERT INTO `posts` SET `category` = ?, `content` = ?;

-- отредактировать пост
UPDATE `posts` SET `category` = ?, `content` = ? WHERE `id` = ?;

-- получить список постов фильтрованный по категории
SELECT * FROM `posts` WHERE `category` = ? ORDER BY `id` DESC;
