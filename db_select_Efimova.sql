# 1. Вывести список фильмов, в которых снимались одновременно 
# Арнольд Шварценеггер* и Линда Хэмилтон*.
# Формат: ID фильма, Название на русском языке, Имя режиссёра.

SELECT 
	MOVIE_ID, 	
    TITLE, 	
    DIRECTOR_ID 
FROM movie_title 
INNER JOIN movie ON movie_title.MOVIE_ID = movie.ID
WHERE MOVIE_ID IN (SELECT MOVIE_ID FROM movie_actor WHERE ACTOR_ID = 1 AND ACTOR_ID = 3) 
AND LANGUAGE_ID = 'ru'; 

# 2. Вывести список названий фильмов на англйском языке с
# "откатом" на русский, в случае если название на английском не задано.
# Формат: ID фильма, Название.

SELECT 
	MOVIE_ID, 
    TITLE
FROM movie_title
WHERE IFNULL(LANGUAGE_ID = 'en', LANGUAGE_ID = 'ru' );

# 3. Вывести самый длительный фильм Джеймса Кэмерона*.
 # Формат: ID фильма, Название на русском языке, Длительность.
# (Бонус – без использования подзапросов)

SELECT 
	MOVIE_ID, 
    TITLE, 
    MAX(LENGTH) AS MAX_LENGHT 
FROM movie 
INNER JOIN movie_title ON  movie.ID = movie_title.MOVIE_ID
WHERE movie.DIRECTOR_ID = 1 AND movie_title.LANGUAGE_ID = 'ru'; 

# 4. ** Вывести список фильмов с названием, сокращённым до 10 символов. 
# Если название короче 10 символов – оставляем как есть. 
# Если длиннее – сокращаем до 10 символов и добавляем многоточие.
 # Формат: ID фильма, сокращённое название

SELECT 	
	MOVIE_ID, 
    IF (CHAR_LENGTH(TITLE)<=10, TITLE, LEFT(TITLE, 10)+'...') AS TITLE
FROM movie_title;


# 5. Вывести количество фильмов, в которых снимался каждый актёр.
  # Формат: Имя актёра, Количество фильмов актёра.

SELECT 
	movie_actor.NAME AS NAME, 
    COUNT(MOVIE_ID) AS MOVIE_COUNT 
FROM movie_actor 
INNER JOIN actor ON movie_actor.ACTOR_ID = actor.ID
GROUP BY movie_actor.NAME;

# 6. Вывести жанры, в которых никогда не снимался Арнольд Шварценеггер*.
  # Формат: ID жанра, название

SELECT
	genre.ID AS ID, 
	genre.NAME AS NAME 
FROM genre 
INNER JOIN movie_genre ON genre.ID = movie_genre.GENRE_ID 
WHERE NOT EXISTS (SELECT 'x' FROM movie_actor 
WHERE movie_actor.MOVIE_ID = movie_genre.MOVIE_ID AND movie_actor.ACTOR_AD = 1)
ORDER BY genre.ID;

# 7. Вывести список фильмов, у которых больше 3-х жанров.
 # Формат: ID фильма, название на русском языке

 SELECT 
	MOVIE_ID, 
    TITLE 
 FROM movie_title 
 INNER JOIN movie_genre ON movie_title.MOVIE_ID =  movie_genre.MOVIE_ID
 GROUP BY movie_title.MOVIE_ID
 HAVING movie_title.LANGUAGE_ID = 'ru' AND COUNT(movie_genre.GENRE_ID)>3;

# 8. Вывести самый популярный жанр для каждого актёра.
# Формат вывода: Имя актёра, Жанр, в котором у актёра больше всего фильмов.

SELECT 
	actor.NAME AS NAME, 
    COUNT(genre.NAME) AS GENRE 
FROM actor 
INNER JOIN movie_actor ON actor.ID = movie_actor.ACTOR_ID 
INNER JOIN movie_genre ON movie_actor.MOVIE_ID =  movie_genre.MOVIE_ID 
INNER JOIN genre ON movie_genre.GENRE_ID = genre.ID 
ORDER BY COUNT(genre.NAME) DESC LIMIT 1;


# * Во всех запросах по конкретному актёру / режиссёру, можно в запросы 
# сразу подставлять ID актёра  / режиссёра. Поиск по имени делать не требуется.

# ** Обратите внимание, что для подсчета длины строки в символах, а не байтах, 
# в MySQL используется используется функция LENGTH_CHAR