--Создаем документный класс (таблицу)
CREATE CLASS words_doc

--Изменим INSERTы из Aqua Data Studio
--Search
--;
--INSERT INTO words_doc(wordid, lemma)
--  VALUES
--Replace
--,
--------------------
--Спецсимволы экранируем!
--например '' заменяем на \'
--Должно получиться что-то типа:
INSERT INTO words_doc(wordid, lemma)
VALUES(405, 'ab'), (406, 'ab\'s initio'), (407, 'aba'), (408, 'aba transit number'), (409, 'abaca')

--Создаем графовый класс и вершину
CREATE CLASS V
CREATE CLASS E
CREATE CLASS words_graph EXTENDS V

CREATE VERTEX words_graph
INSERT INTO words_graph FROM SELECT FROM words_doc

DELETE VERTEX words_graph
