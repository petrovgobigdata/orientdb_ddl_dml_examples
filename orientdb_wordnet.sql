--Создаем графовые классы
CREATE CLASS V
CREATE CLASS E
--Создаем классы вершину и ребро
CREATE CLASS words_v EXTENDS V
CREATE CLASS has_syn_e EXTENDS E

--INSERT INTO words_v FROM SELECT FROM words_doc

SELECT FROM words_v
SELECT EXPAND( OUT() ) FROM words_v where wordid = 405
SELECT EXPAND( BOTH( 'has_syn_e' ) ) FROM words_v where wordid = 405

DELETE EDGE has_syn_e LIMIT 1000000
DELETE VERTEX words_v LIMIT 1000000
