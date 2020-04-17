CREATE CLASS ypedu_person_v EXTENDS V;
CREATE PROPERTY ypedu_person_v.person_id STRING;
CREATE PROPERTY ypedu_person_v.person_fname STRING;
CREATE PROPERTY ypedu_person_v.person_sname STRING;
CREATE PROPERTY ypedu_person_v.person_age STRING;
CREATE PROPERTY ypedu_person_v.person_sex STRING;
CREATE INDEX ypedu_person_v.ui_ypedu_person_v_person_id ON ypedu_person_v (person_id) UNIQUE

CREATE CLASS has_family_link_e EXTENDS E;
CREATE PROPERTY has_family_link_e.in LINK;
CREATE PROPERTY has_family_link_e.out LINK

$ORIENTDB_HOME/bin/oetl.sh /opt/oetl/sqlunet/scripts/ypedu_01.hierarchy.json
$ORIENTDB_HOME/bin/oetl.sh /opt/oetl/sqlunet/scripts/ypedu_02.hierarchy.json
