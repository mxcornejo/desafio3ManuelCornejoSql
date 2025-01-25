-- 1. Creación de la base de datos
CREATE DATABASE desafio3_manuel_cornejo_789;

-- Usar la base de datos
\c desafio3_manuel_cornejo_789;

-- 2. Creación de las tablas

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    rol VARCHAR(20)
);

-- Crear la tabla de posts
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255),
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT REFERENCES usuarios(id)
);

-- Crear la tabla de comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT REFERENCES usuarios(id),
    post_id BIGINT REFERENCES posts(id)
);

-- 3. Insertar los datos en las tablas

-- Insertar usuarios
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES
(DEFAULT, 'juan@mail.com', 'juan', 'perez', 'administrador'),
(DEFAULT, 'diego@mail.com', 'diego', 'munoz', 'usuario'),
(DEFAULT, 'maria@mail.com', 'maria', 'meza', 'usuario'),
(DEFAULT, 'roxana@mail.com', 'roxana', 'diaz', 'usuario'),
(DEFAULT, 'pedro@mail.com', 'pedro', 'diaz', 'usuario');

-- Insertar posts
INSERT INTO posts(id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
(DEFAULT, 'prueba', 'contenido prueba', '2021-01-01', '2021-02-01', true, 1),
(DEFAULT, 'prueba2', 'contenido prueba2', '2021-03-01', '2021-03-01', true, 1),
(DEFAULT, 'ejercicios', 'contenido ejercicios', '2021-05-02', '2021-04-03', true, 2),
(DEFAULT, 'ejercicios2', 'contenido ejercicios2', '2021-05-03', '2021-04-04', false, 2),
(DEFAULT, 'random', 'contenido random', '2021-06-03', '2021-05-04', false, NULL);

-- Insertar comentarios
INSERT INTO comentarios(id, contenido, fecha_creacion, usuario_id, post_id) VALUES
(DEFAULT, 'comentario 1', '2021-06-03', 1, 1),
(DEFAULT, 'comentario 2', '2021-06-03', 2, 1),
(DEFAULT, 'comentario 3', '2021-06-04', 3, 1),
(DEFAULT, 'comentario 4', '2021-06-04', 1, 2),
(DEFAULT, 'comentario 5', '2021-06-04', 2, 2);

-- 4. Consultas requeridas

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
-- nombre y email del usuario junto al título y contenido del post.
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
SELECT p.id, p.titulo, p.contenido
FROM posts p
JOIN usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 5. Muestra el email del usuario que ha creado más posts.
SELECT u.email
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.
SELECT u.email, MAX(p.fecha_creacion) AS ultimo_post
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email;

-- 7. Muestra el título y contenido del post con más comentarios.
SELECT p.titulo, p.contenido
FROM posts p
JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

-- 8. Muestra el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts, junto con el email del usuario que lo escribió.
SELECT p.titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email
FROM posts p
JOIN comentarios c ON p.id = c.post_id
JOIN usuarios u ON c.usuario_id = u.id;

-- 9. Muestra el contenido del último comentario de cada usuario.
SELECT u.email, c.contenido AS ultimo_comentario
FROM usuarios u
JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id);

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
