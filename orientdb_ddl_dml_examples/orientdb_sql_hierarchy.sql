--Проход по графу - Traverse
http://orientdb.com/docs/3.0.x/sql/SQL-Traverse.html

Vertex to outgoing edges Using outE() or outE('EdgeClassName'). That is, going out from a vertex and into the outgoing edges.
Vertex to incoming edges Using inE() or inE('EdgeClassName'). That is, going from a vertex and into the incoming edges.
Vertex to all edges Using bothE() or bothE('EdgeClassName'). That is, going from a vertex and into all the connected edges.
Edge to Vertex (end point) Using inV() . That is, going out from an edge and into a vertex.
Edge to Vertex (starting point) Using outV() . That is, going back from an edge and into a vertex.
Edge to Vertex (both sizes) Using bothV() . That is, going from an edge and into connected vertices.
Vertex to Vertex (outgoing edges) Using out() or out('EdgeClassName'). This is the same as outE().inV()
Vertex to Vertex (incoming edges) Using in() or in('EdgeClassName'). This is the same as outE().inV()
Vertex to Vertex (all directions) Using both() or both('EdgeClassName')

--Отобразим всю семью Jack Smith (person_id = 3), включая его самого
--От вершины с person_id = 3 проходим по всем ребрам как OUT так и IN
TRAVERSE both(has_family_link_e) from (select from ypedu_person_v where person_id = 3)
--Отобразим всех потомков Jack Smith (person_id = 3), не включая его самого
TRAVERSE in(has_family_link_e) from (select from ypedu_person_v where person_id = 3)
--Отобразим всех предков Jack Smith (person_id = 3), не включая его самого
TRAVERSE out(has_family_link_e) from (select from ypedu_person_v where person_id = 3)

