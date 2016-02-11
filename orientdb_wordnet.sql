--Создаем графовые классы
CREATE CLASS V
CREATE CLASS E
--Создаем классы вершину и ребро
CREATE CLASS words_v EXTENDS V
CREATE CLASS senses_v EXTENDS V
CREATE CLASS has_link_e EXTENDS E
CREATE CLASS has_senses_e EXTENDS E

--INSERT INTO words_v FROM SELECT FROM words_doc

SELECT FROM words_v
SELECT FROM words_v where wordid = 405
--Отобрать только те записи у которых есть исходящие ребра (есть синонимы)
SELECT FROM words_v where outE().size() > 0 limit 100
--Отобрать только те слова у которых есть синонимы но которые не являются синонимом ни для кого
SELECT FROM words_v where outE().size() > 0 and inE().size() = 0 limit 100
--Отобрать только те записи у которых есть > 10 синонимов
SELECT *, OUT().lemma FROM words_v where outE().size() > 10 limit 100
--Отобрать только те записи у которых есть > 10 синонимов и транспонировать
SELECT *, OUT().lemma as lemma_tr FROM words_v where outE().size() > 10 UNWIND lemma_tr limit 100

select wordid, IN('has_senses_e').lemma as lemma, synsetid, outE('has_link_e').linktype[0] as linktype, OUT('has_link_e').wordid as wordid_link
from senses_v 
where outE('has_link_e').linktype[0] = 'synonym' 
order by wordid UNWIND lemma, wordid_link
limit 1000

DELETE EDGE has_senses_e LIMIT 1000000
DELETE EDGE has_link_e LIMIT 1000000
DELETE VERTEX words_v LIMIT 1000000
DELETE VERTEX senses_v LIMIT 1000000
