USE imdb;

SELECT * FROM movie;

#1 Count number of rows for each column?
SELECT count(*) from movie;

#2 Which columns in the movie table are having null values?
SELECT 
SUM(CASE WHEN SaleID IS NULL THEN 1 ELSE 0 END) AS ID_NULL_COUNT,
SUM(CASE WHEN Salesperson IS NULL THEN 1 ELSE 0 END) AS SP_NULL_COUNT,
SUM(CASE WHEN SaleAmount IS NULL THEN 1 ELSE 0 END) AS SA_NULL_COUNT,
SUM(CASE WHEN SaleDate IS NULL THEN 1 ELSE 0 END) AS SD_NULL_COUNT
FROM Sales_extended;

#3 Find total number of movies released each year ? How does the trend look month wise?
SELECT count(id) as num_of_movies, year
FROM movie
GROUP BY year;

#4 Number of movies released each month?
SELECT Month(date_published) as Month_num, count(*) as Number_of_movies
FROM movie
GROUP BY Month_num
ORDER BY Month_num;
 
#5. How many movies were produced in the USA or India in the year 2019?
SELECT COUNT(DISTINCT(id)) as num_of_movies, year
FROM movie
WHERE country like '%India%' or country like'%USA%'
GROUP BY year
HAVING year = 2019;

#6 Find unique list of genre present in the dataset?
SELECT count(distinct genre) as unique_genre 
FROM genre;

SELECT * FROM genre;

#7 Which genre has the highest number of movies?
SELECT g.genre , count(m.id) as num_movie
FROM movie m
INNER JOIN genre g on m.id = g.movie_id
GROUP BY g.genre
ORDER BY num_movie DESC
LIMIT 1;

#8 How many movies belong to only one genre?
WITH GenreCount AS (
				SELECT m.id , count(g.genre) as num_genre
				FROM movie m
				INNER JOIN genre g on m.id = g.movie_id
				GROUP BY m.id)

SELECT Count(*) AS num_movies_with_one_genre
FROM GenreCount
WHERE num_genre = 1; 

#9 What is the average duration of movies in each genre?
SELECT round(avg(m.duration), 2) as avg_duration, g.genre
from movie m
INNER JOIN genre g on g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;

#10 What is the rank of 'Thriller' genre in nterms of number of movies produced?
#SELECT genre, 
#COUNT(movie_id) as num_movies,
#rank() over (order by COUNT(movie_id) DESC) as rank_genre
#from genre
#WHERE genre = 'thriller'
#group by genre;

WITH genre_summary AS(
			SELECT genre, 
			COUNT(movie_id) as num_movies,
			rank() over (order by COUNT(movie_id) DESC) as rank_genre
			from genre
			group by genre	
)

SELECT * FROM genre_summary WHERE genre = 'thriller';

SELECT * FROM ratings;

#11 Summarize the ratings table based on movie counts by median ratings?
SELECT median_rating,
COUNT(movie_id) as movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

#12 Which production house has produced most hit movies (average rating > 8)?
WITH MovieRatings AS (
  SELECT
    m.production_company,
    count(m.id) as Movie_Count,
    RANK() OVER (ORDER BY count(m.id) DESC) AS Prod_comp_Rank
  FROM
    movie m
  INNER JOIN ratings r ON r.movie_id = m.id
  WHERE r.avg_rating > 8
  AND m.production_company IS NOT NULL
  GROUP BY m.production_company
)

SELECT * FROM MovieRatings
WHERE Prod_comp_Rank = 1;

#13 How many movies were released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT genre, count(m.id) as movie_count
FROM movie m 
INNER JOIN genre g on g.movie_id = m.id
INNER JOIN ratings r on r.movie_id = m.id
where year = 2017 and month(date_published) = 3
and country like '%USA%'
and total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

#14 Find movies of each genre starting with 'The' and having average rating > 8?
SELECT title, avg_rating, genre
FROM movie m
INNER JOIN genre g on g.movie_id = m.id
INNER JOIN ratings r on r.movie_id = m.id
WHERE avg_rating > 8
AND title like 'The%'
ORDER BY avg_rating DESC;

#15 You should also try your hand at median rating and check whether the 'median rating' column gives any significant insights.
# Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
SELECT median_rating, COUNT(*) as Movie_count
FROM movie m
INNER JOIN ratings r on r.movie_id = m.id
WHERE median_rating = 8
AND date_published between '2018-04-01' and '2019-04-01'
GROUP BY median_rating;

#16 Do German movies got more votes than Italian movies?
SELECT Sum(total_votes) AS VOTES, country
FROM movie m
INNER JOIN ratings r on m.id = r.movie_id
WHERE country in ('Germany', 'Italy')
GROUP BY country;

#17 Which columns in the name table have null values?

SELECT
SUM (CASE WHEN name is null  THEN 1 ELSE 0 END )AS name_nulls,
SUM (CASE WHEN height is null  THEN 1 ELSE 0 END )AS height_nulls,
SUM (CASE WHEN date_of_birth is null  THEN 1 ELSE 0 END )AS date_of_birth_nulls,
SUM (CASE WHEN known_for_movies is null  THEN 1 ELSE 0 END )AS known_for_movies_nulls
FROM names;


#18 Q19. Who are the top three directors in the top three genres whose movies have an average rating 8? 
#(Hint: The top three genres would have the most number of movies with an average rating > 8.)
