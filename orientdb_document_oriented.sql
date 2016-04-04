create class party
create property party.addr EMBEDDED
create property party.addr.date_from date
create property party.addr.date_to date

INSERT INTO party CONTENT {
    "name": "Yury",
    "sex": "M",
    "birthday": "1985-01-15",
    "addr": [
        {"location": "Саратов", "street": "Новая", "home": "15", "date_from": "1985-01-15", "date_to": "1997-05-25"}
        {"location": "Серпухов", "street": "Мира", "home": "29", "date_from": "1997-05-25", "date_to": "1998-07-19"}
        {"location": "Подольск", "street": "Парковая", "home": "17", "date_from": "1998-07-19", "date_to": "2005-05-15"}
        {"location": "Москва", "street": "Лесная", "home": "5", "date_from": "2005-05-15", "date_to": "3000-01-01"}
    ]
}

select name, sex, birthday, addr.location, addr.street, addr.home, addr.date_from, addr.date_to from party

select name, sex, birthday, addr[date_from.asDate() = "2005-05-15"].date_from.asDate()
from party
