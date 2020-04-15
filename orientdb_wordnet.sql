--=====================================--
--Определим объекты для словаря WORDNET
--=====================================--
--Создаем графовые классы
CREATE CLASS V
CREATE CLASS E

--Создаем последовательность (для автоинкремента)
CREATE SEQUENCE sqlunet_wordid TYPE ORDERED START 0 INCREMENT 1;
CREATE SEQUENCE sqlunet_synsetid TYPE ORDERED START 0 INCREMENT 1;
CREATE SEQUENCE sqlunet_sample_seq TYPE ORDERED START 0 INCREMENT 1
--Создаем вершины и ребра словаря
CREATE CLASS words_v EXTENDS V;
CREATE PROPERTY words_v.wordid_seq LONG;
CREATE PROPERTY words_v.wordid STRING;
CREATE PROPERTY words_v.wordtypeid STRING;
--CREATE PROPERTY words_v.casedwordid STRING;
--CREATE PROPERTY words_v.morphid STRING;
CREATE PROPERTY words_v.lemma STRING;
CREATE PROPERTY words_v.wordtype STRING;
CREATE PROPERTY words_v.origin STRING;
CREATE INDEX words_v.nui_words_v_lemma ON words_v (lemma) NOTUNIQUE;
CREATE INDEX words_v.nui_words_v_wordid ON words_v (wordid) NOTUNIQUE;
CREATE INDEX words_v.nui_words_v_wordid_seq ON words_v (wordid_seq) NOTUNIQUE

CREATE CLASS senses_v EXTENDS V;
CREATE PROPERTY senses_v.synsetid_seq LONG;
CREATE PROPERTY senses_v.synsetid STRING;
CREATE PROPERTY senses_v.wordid STRING;
CREATE PROPERTY senses_v.definition STRING;
--Добавить origin в следующих версиях
CREATE INDEX senses_v.nui_senses_v_synsetid_seq ON senses_v (synsetid_seq) NOTUNIQUE;
CREATE INDEX senses_v.nui_senses_v_synsetid ON senses_v (synsetid) NOTUNIQUE
CREATE INDEX senses_v.nui_senses_v_wordid ON senses_v (wordid) NOTUNIQUE;

CREATE CLASS samples_v EXTENDS V;
CREATE PROPERTY samples_v.synsetid_seq LONG;
CREATE PROPERTY samples_v.sample_seq LONG;
CREATE PROPERTY samples_v.synsetid STRING;
CREATE PROPERTY samples_v.wordid STRING;
CREATE PROPERTY samples_v.sample_num STRING;
CREATE PROPERTY samples_v.sample STRING;
--Добавить origin в следующих версиях
CREATE INDEX samples_v.nui_samples_v_synsetid ON samples_v (synsetid) NOTUNIQUE;
CREATE INDEX samples_v.nui_samples_v_synsetid_seq ON samples_v (synsetid_seq) NOTUNIQUE;
CREATE INDEX samples_v.nui_samples_v_sample_seq ON samples_v (sample_seq) NOTUNIQUE

--Отношения слово-значение
CREATE CLASS has_senses_e EXTENDS E;
CREATE PROPERTY has_senses_e.posname STRING;
CREATE PROPERTY has_senses_e.origin STRING;
CREATE PROPERTY has_senses_e.wordtype STRING;
CREATE PROPERTY has_senses_e.in LINK;
CREATE PROPERTY has_senses_e.out LINK;
CREATE INDEX has_senses_e.ui_has_senses_e ON has_senses_e (out, in, origin, wordtype, posname) UNIQUE
--Отношения между значениями - синонимы, антонимы и т.д.
CREATE CLASS has_link_e EXTENDS E;
CREATE PROPERTY has_link_e.linktype STRING;
CREATE PROPERTY has_link_e.linkgroup STRING;
CREATE PROPERTY has_link_e.origin STRING;
CREATE PROPERTY has_link_e.in LINK;
CREATE PROPERTY has_link_e.out LINK;
CREATE INDEX has_link_e.ui_has_link_e ON has_link_e (out, in, origin, linkgroup, linktype) UNIQUE
--Отношения значения-примеры использования
CREATE CLASS has_samples_e EXTENDS E;
CREATE PROPERTY has_samples_e.origin STRING;
CREATE PROPERTY has_samples_e.in LINK;
CREATE PROPERTY has_samples_e.out LINK;
CREATE INDEX has_samples_e.ui_has_samples_e ON has_samples_e (out, in, origin) UNIQUE
--Ссылки в words_v на себя, например слова в других регистрах (casedwords) и т.д.
CREATE CLASS has_wordslink_e EXTENDS E;
CREATE PROPERTY has_wordslink_e.origin STRING;
CREATE PROPERTY has_wordslink_e.wordtype STRING;
CREATE PROPERTY has_wordslink_e.in LINK;
CREATE PROPERTY has_wordslink_e.out LINK;
CREATE INDEX has_wordslink_e.ui_has_wordslink_e ON has_wordslink_e (out, in, origin, wordtype) UNIQUE

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

select
IN('has_senses_e').lemma as lemma
,outE('has_link_e').linktype as linktype
from senses_v
where outE('has_link_e') contains (linktype = 'antonym')
--SAME, but not correct
--where outE('has_link_e')[linktype = 'antonym'].linktype[0] = 'antonym'
--UNWIND lemma, linktype

                                                       
--Бреем первое значение [0] из типа EMBEDDEDLIST
select IN('has_senses_e').wordid_seq[0] as wordid_seq, * from senses_v

--Слова, у которых нет ребра has_senses_e с атрибутом wordtype = 'casedword'
select * from words_v where wordid = 405 and outE('has_senses_e')[wordtype = 'casedword'].size() = 0

select $a.wordid, $a.posname as aa from senses_v LET $a = (select from $parent.$current) unwind aa

select in.wordid as wordid, in.in('has_senses_e').lemma as lemma, linktype, out.wordid as wordid_link, out.synsetid as synsetid_link, out.in('has_senses_e').lemma as lemma_link
from has_link_e
where in.wordid = 28127 and in.synsetid = 300006050 and linktype = 'antonym'
unwind lemma, lemma_link

--Обновление атрибута origin
UPDATE senses_v SET origin = 'Luca' WHERE IN('has_senses_e').wordid_seq[0] = 19
                                                       
DELETE EDGE has_senses_e LIMIT 1000000
DELETE EDGE has_link_e LIMIT 1000000
DELETE EDGE has_samples_e
DELETE EDGE has_wordslink_e
DELETE VERTEX words_v LIMIT 1000000
DELETE VERTEX senses_v LIMIT 1000000
DELETE VERTEX samples_v

