drop trigger dodanie_rezerwacji_log;
drop trigger zmiana_statusu_rezerwacji_log;
drop trigger zabron_usuniecie_rezerwacji;
drop trigger dodanie_rezerwacji_odswiez_wolne_miejsca;
drop trigger zmiana_statusu_rezerwacji_odswiez_wolne_miejsca;
drop trigger zmiana_liczby_miejsc_wycieczki_sprawdz;
drop trigger dodanie_wycieczki_ustaw_wolne_miejsca;
drop table REZERWACJE_LOG;
drop table REZERWACJE;
drop table WYCIECZKI;
drop table OSOBY;
drop view wycieczki_osoby;
drop view wycieczki_osoby_potwierdzone;
drop view wycieczki_osoby_przyszle;
drop view wycieczki_miejsca;
drop view dostepne_wycieczki;
drop view rezerwacja_do_anulowania;
drop view wycieczki_miejsca2;
drop view dostepne_wycieczki2;
drop function uczestnicy_wycieczki;
drop function uczestnicy_wycieczki_2;
drop function rezerwacje_osoby;
drop function przyszle_rezerwacje_osoby;
drop function dostepne_wycieczki_fun;
drop function dostepne_wycieczki_fun2;
drop procedure dodaj_rezerwacje;
drop procedure zmien_status_rezerwacji;
drop procedure zmien_liczbe_miejsc;
drop procedure dodaj_rezerwacje2;
drop procedure zmien_status_rezerwacji2;
drop procedure zmien_liczbe_miejsc2;
drop procedure dodaj_rezerwacje3;
drop procedure zmien_status_rezerwacji3;
drop procedure zmien_liczbe_miejsc3;
drop procedure dodaj_rezerwacje4;
drop procedure zmien_status_rezerwacji4;
drop procedure przelicz;
drop type uczestnicy_wycieczki_tab;
drop type uczestnicy_wycieczki_rec;
drop type rezerwacje_osoby_tab;
drop type rezerwacje_osoby_rec;
drop type dostepne_wycieczki_tab;
drop type dostepne_wycieczki_rec;

CREATE TYPE uczestnicy_wycieczki_rec AS OBJECT (
  NAZWA    VARCHAR2(50),
  KRAJ     VARCHAR2(50),
  DATA     DATE,
  IMIE     VARCHAR2(50),
  NAZWISKO VARCHAR2(50),
  STATUS   CHAR(1)
);
CREATE TYPE uczestnicy_wycieczki_tab IS TABLE OF uczestnicy_wycieczki_rec;

CREATE TYPE rezerwacje_osoby_rec AS OBJECT (
  NAZWA    VARCHAR2(50),
  KRAJ     VARCHAR2(50),
  DATA     DATE,
  IMIE     VARCHAR2(50),
  NAZWISKO VARCHAR2(50),
  STATUS   CHAR(1)
);
CREATE TYPE rezerwacje_osoby_tab IS TABLE OF rezerwacje_osoby_rec;

CREATE TYPE dostepne_wycieczki_rec AS OBJECT (
  DATA          DATE,
  NAZWA         VARCHAR2(50),
  MIEJSCA       INT,
  WOLNE_MIEJSCA INT
);
CREATE TYPE dostepne_wycieczki_tab IS TABLE OF dostepne_wycieczki_rec;

-- 1)

CREATE TABLE OSOBY
(
  ID_OSOBY INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  IMIE     VARCHAR2(50)
  ,
  NAZWISKO VARCHAR2(50)
  ,
  PESEL    VARCHAR2(11)
  ,
  KONTAKT  VARCHAR2(100)
  ,
  CONSTRAINT OSOBY_PK PRIMARY KEY
    (
      ID_OSOBY
    )
  ENABLE
);


CREATE TABLE WYCIECZKI
(
  ID_WYCIECZKI          INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  NAZWA                 VARCHAR2(100)
  ,
  KRAJ                  VARCHAR2(50)
  ,
  DATA                  DATE
  ,
  OPIS                  VARCHAR2(200)
  ,
  LICZBA_MIEJSC         INT
  ,
  LICZBA_WOLNYCH_MIEJSC INT     -- Modyfikacja do 7ego zadania
  ,
  CONSTRAINT WYCIECZKI_PK PRIMARY KEY
    (
      ID_WYCIECZKI
    )
  ENABLE
);


CREATE TABLE REZERWACJE
(
  NR_REZERWACJI INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  ID_WYCIECZKI  INT
  ,
  ID_OSOBY      INT
  ,
  STATUS        CHAR(1)
  ,
  CONSTRAINT REZERWACJE_PK PRIMARY KEY
    (
      NR_REZERWACJI
    )
  ENABLE
);


ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_FK1 FOREIGN KEY
  (
    ID_OSOBY
  )
REFERENCES OSOBY
  (
    ID_OSOBY
  )
ENABLE;

ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_FK2 FOREIGN KEY
  (
    ID_WYCIECZKI
  )
REFERENCES WYCIECZKI
  (
    ID_WYCIECZKI
  )
ENABLE;

ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_CHK1 CHECK
(status IN ('N', 'P', 'Z', 'A'))
ENABLE;

-- 6)

CREATE TABLE REZERWACJE_LOG
(
  ID_REZEZRWACJI_LOG INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  NR_REZERWACJI      INT
  ,
  DATA               DATE
  ,
  STATUS             CHAR(1)
  ,
  CONSTRAINT REZERWACJE_LOG_PK PRIMARY KEY
    (
      ID_REZEZRWACJI_LOG
    )
  ENABLE
);

ALTER TABLE REZERWACJE_LOG
  ADD CONSTRAINT REZERWACJE_LOG_FK1 FOREIGN KEY
  (
    NR_REZERWACJI
  )
REFERENCES REZERWACJE
  (
    NR_REZERWACJI
  )
ENABLE;

-------------------------------------------------------------------

-- 2)

INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Kowalski', '87654321', 'tel: 6623');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Jan', 'Nowak', '12345678', 'tel: 2312, dzwonić po 18.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Michal', 'Baran', '86554321', 'tel: 1234');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Tomasz', 'Pajak', '12345654', 'tel: 6431');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Nowak', '87633321', 'tel: 6223');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Jan', 'Pajak', '12301678', 'tel: 2392');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Michal', 'Kowalski', '12554321', 'tel: 9934');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Tomasz', 'Nowak', '12345894', 'tel: 6999');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Adamski', '99654321', 'tel: 6653');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Jan', 'Janowski', '19945678', 'tel: 9999');

INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wycieczka do Paryza', 'Francja', '2016-01-01', 'Ciekawa wycieczka ...', 3);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Piękny Kraków', 'Polska', '2017-02-03', 'Najciekawa wycieczka ...', 2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka', 'Polska', '2018-03-03', 'Zadziwiająca kopalnia ...', 2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka2', 'Polska', TO_DATE('2019-03-03', 'YYYY-MM-DD'), 'Zadziwiająca kopalnia ...', 3);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wycieczka do Paryza', 'Francja', '2018-10-22', 'Ciekawa wycieczka ...', 3);

INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 1, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 2, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 3, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (2, 1, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (2, 2, 'Z');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (3, 5, 'Z');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (3, 6, 'A');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (4, 9, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (4, 10, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (4, 10, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (5, 9, 'N');


---------------------------------------------------------------------------
-- 3)
-- a)
CREATE VIEW wycieczki_osoby
  AS
    SELECT o.ID_OSOBY, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;

-- b)
CREATE VIEW wycieczki_osoby_potwierdzone
  AS
    SELECT ID_OSOBY, KRAJ, NAZWA, DATA, IMIE, NAZWISKO, STATUS
    FROM wycieczki_osoby
    WHERE STATUS = 'P';
-- c)
CREATE VIEW wycieczki_osoby_przyszle
  AS
    SELECT ID_OSOBY, KRAJ, NAZWA, DATA, IMIE, NAZWISKO, STATUS
    FROM wycieczki_osoby
    WHERE DATA > SYSDATE;
-- d)
CREATE VIEW wycieczki_miejsca
  AS
    SELECT r.ID_WYCIECZKI, KRAJ, DATA, NAZWA, LICZBA_MIEJSC, LICZBA_MIEJSC - COUNT(r.ID_WYCIECZKI) LICZBA_WOLNYCH_MIEJSC
    FROM REZERWACJE r
           JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    WHERE r.STATUS != 'A'
    GROUP BY r.ID_WYCIECZKI, w.KRAJ, w.LICZBA_MIEJSC, w.NAZWA, w.DATA;
-- e)
CREATE VIEW dostepne_wycieczki
  AS
    SELECT *
    FROM (SELECT r.ID_WYCIECZKI,
                 KRAJ,
                 DATA,
                 NAZWA,
                 LICZBA_MIEJSC,
                 LICZBA_MIEJSC - COUNT(r.ID_WYCIECZKI) AS LICZBA_WOLNYCH_MIEJSC
          FROM REZERWACJE r
                 JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
          WHERE w.DATA > SYSDATE
            AND r.STATUS != 'A'
          GROUP BY r.ID_WYCIECZKI, w.KRAJ, w.LICZBA_MIEJSC, w.NAZWA, w.DATA)
    WHERE LICZBA_WOLNYCH_MIEJSC > 0;
-- f)
CREATE VIEW rezerwacja_do_anulowania
  AS
    SELECT r.NR_REZERWACJI
    FROM REZERWACJE r
           JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    WHERE r.STATUS = 'N'
      AND (SELECT w.DATA - SYSDATE FROM DUAL) <= 7
      AND w.DATA > SYSDATE;

--------------------------------------------------------------------------------

-- 4 )

-- a)
-- OVERKILL jak nic, ale przynajmniej nie wywali OutOfMemoryException dla duzych tablic
CREATE FUNCTION uczestnicy_wycieczki(id_wycieczki_arg IN INT)
  RETURN uczestnicy_wycieczki_tab PIPELINED AS
  result uczestnicy_wycieczki_rec := uczestnicy_wycieczki_rec(NULL, NULL, NULL, NULL, NULL, NULL);
  Nie_Ma_Takiej_Wycieczki EXCEPTION;
  ilosc_znalezionych INT;
  CURSOR c_result IS
    (SELECT w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
     FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
     WHERE w.ID_WYCIECZKI = id_wycieczki_arg);
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    where id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    OPEN c_result;
    LOOP
      FETCH c_result INTO result.NAZWA, result.KRAJ, result.DATA,
      result.IMIE, result.NAZWISKO, result.STATUS;
      EXIT WHEN c_result%notfound;
      PIPE ROW (result);
    END LOOP;
    CLOSE c_result;
    RETURN;
    EXCEPTION
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
  END;
-- Dobre, gdy tabela wynikowa jest mala, gdy jest duza lepiej jechac na cursorze
CREATE FUNCTION uczestnicy_wycieczki_2(id_wycieczki_arg IN INT)
  RETURN uczestnicy_wycieczki_tab AS
  result uczestnicy_wycieczki_tab := uczestnicy_wycieczki_tab();
  Nie_Ma_Takiej_Wycieczki EXCEPTION;
  ilosc_znalezionych INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    where id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    SELECT uczestnicy_wycieczki_rec(w.NAZWA,
                                    w.KRAJ,
                                    w.DATA,
                                    o.IMIE,
                                    o.NAZWISKO,
                                    r.STATUS)
        BULK COLLECT INTO result
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE w.ID_WYCIECZKI = id_wycieczki_arg;
    RETURN result;
    EXCEPTION
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
  END;

--b)
CREATE FUNCTION rezerwacje_osoby(id_osoby_arg IN INT)
  RETURN rezerwacje_osoby_tab AS
  result rezerwacje_osoby_tab := rezerwacje_osoby_tab();
  Nie_Ma_Takiej_Osoby EXCEPTION;
  ilosc_znalezionych INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby
    where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT rezerwacje_osoby_rec(w.NAZWA,
                                w.KRAJ,
                                w.DATA,
                                o.IMIE,
                                o.NAZWISKO,
                                r.STATUS)
        BULK COLLECT INTO result
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE o.ID_OSOBY = id_osoby_arg;
    RETURN result;
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      dbms_output.put_line('Blad! Nie ma takiej osoby.');
  END;

--c)
CREATE FUNCTION przyszle_rezerwacje_osoby(id_osoby_arg IN INT)
  RETURN rezerwacje_osoby_tab AS
  result             rezerwacje_osoby_tab := rezerwacje_osoby_tab();
    Nie_Ma_Takiej_Osoby EXCEPTION;
  ilosc_znalezionych INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby
    where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT rezerwacje_osoby_rec(NAZWA, KRAJ, DATA, IMIE, NAZWISKO, STATUS)
        BULK COLLECT INTO result
    FROM wycieczki_osoby_przyszle
    WHERE ID_OSOBY = id_osoby_arg;
    RETURN result;
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      dbms_output.put_line('Blad! Nie ma takiej osoby.');
  END;

--d)
CREATE FUNCTION dostepne_wycieczki_fun(kraj_arg IN STRING, data_od_arg IN DATE, data_do_arg IN DATE)
  RETURN dostepne_wycieczki_tab AS
  result dostepne_wycieczki_tab := dostepne_wycieczki_tab();
    Zly_Format_Dat EXCEPTION;
  BEGIN
    IF (data_do_arg < SYSDATE OR data_do_arg < data_od_arg)
    THEN
      RAISE Zly_Format_Dat;
    END IF;
    SELECT dostepne_wycieczki_rec(DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC)
        BULK COLLECT INTO result
    FROM dostepne_wycieczki
    WHERE KRAJ like kraj_arg
      AND (DATA BETWEEN data_od_arg AND data_do_arg);
    RETURN result;
    EXCEPTION
    WHEN Zly_Format_Dat
    THEN
      dbms_output.put_line('Blad! Podane daty sa nieodpowiednie.');
  END;

-----------------------------------------------------------------------------------

-- 5)

--a)
CREATE PROCEDURE dodaj_rezerwacje(id_wycieczki_arg IN INT, id_osoby_arg IN INT) AS
    Nie_Ma_Takiej_Osoby EXCEPTION;
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Wycieczka_Niedostepna EXCEPTION;
  ilosc_znalezionych INT;
  nowy_nr_rezerwacji INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    SELECT COUNT(*) INTO ilosc_znalezionych FROM dostepne_wycieczki WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Wycieczka_Niedostepna;
    END IF;
    INSERT INTO rezerwacje (id_wycieczki, id_osoby, status) VALUES (id_wycieczki_arg, id_osoby_arg, 'N');
    SELECT NR_REZERWACJI INTO nowy_nr_rezerwacji
    FROM rezerwacje r
    WHERE r.ID_WYCIECZKI = id_wycieczki_arg
      AND r.ID_OSOBY = id_osoby_arg;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS) VALUES (nowy_nr_rezerwacji, SYSDATE, 'N');
    COMMIT;
    dbms_output.put_line('Dokonano rezerwacji.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej osoby.');
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Wycieczka_Niedostepna
    THEN
      dbms_output.put_line('Blad! Podana wycieczka jest niedostepna.');
  END;

--b)
CREATE PROCEDURE zmien_status_rezerwacji(id_rezerwacji_arg IN INT, status_arg IN CHAR) AS
  Nie_Ma_Takiej_Rezerwacji EXCEPTION;
  Nieprawidlowa_Operacja EXCEPTION;
  Brak_Wolnych_Miejsc EXCEPTION;
  Wycieczka_Juz_Miaja_Miejsce EXCEPTION;
  ilosc_znalezionych      INT;
  znaleziony_id_wycieczki INT;
  data_wycieczki          DATE;
  znaleziony_status       CHAR(1);
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM rezerwacje
    where nr_rezerwacji = id_rezerwacji_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Rezerwacji;
    END IF;
    SELECT STATUS INTO znaleziony_status FROM rezerwacje
    WHERE NR_REZERWACJI = id_rezerwacji_arg;
    IF (znaleziony_status = status_arg)
    THEN
      RETURN;
    END IF;
    IF (status_arg NOT IN ('N', 'P', 'Z', 'A'))
    THEN
      RAISE Nieprawidlowa_Operacja;
    END IF;
    IF (znaleziony_status = 'A')
    THEN
      SELECT ID_WYCIECZKI INTO znaleziony_id_wycieczki FROM REZERWACJE
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      SELECT DATA INTO data_wycieczki FROM wycieczki w
      WHERE w.ID_WYCIECZKI = znaleziony_id_wycieczki;
      IF (data_wycieczki > SYSDATE)
      THEN
        SELECT LICZBA_WOLNYCH_MIEJSC INTO ilosc_znalezionych
        FROM wycieczki_miejsca dw
        WHERE dw.ID_WYCIECZKI = znaleziony_id_wycieczki;
        IF (ilosc_znalezionych > 0)
        THEN
          UPDATE REZERWACJE SET STATUS = status_arg
          WHERE NR_REZERWACJI = id_rezerwacji_arg;
          INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
          VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
        ELSE
          RAISE Brak_Wolnych_Miejsc;
        END IF;
      ELSE
        RAISE Wycieczka_Juz_Miaja_Miejsce;
      END IF;
    ELSE IF (znaleziony_status = 'N')
    THEN
      UPDATE REZERWACJE SET STATUS = status_arg
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
      VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
    ELSE IF (znaleziony_status = 'P')
    THEN
      IF (status_arg = 'N')
      THEN
        RAISE Nieprawidlowa_Operacja;
      ELSE
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
        INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
        VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
      END IF;
    ELSE IF (znaleziony_status = 'Z')
    THEN
      IF (status_arg = 'A')
      THEN
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
        INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
        VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
      ELSE
        RAISE Nieprawidlowa_Operacja;
      END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    COMMIT;
    dbms_output.put_line('Operacja wykonana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Rezerwacji
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej rezerwacji.');
    WHEN Nieprawidlowa_Operacja
    THEN
      DBMS_OUTPUT.put_line('Blad! Niedozwolona operacja.');
    WHEN Brak_Wolnych_Miejsc
    THEN
      DBMS_OUTPUT.put_line('Blad! Brak wolnych miejsc.');
    WHEN Wycieczka_Juz_Miaja_Miejsce
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie mozna aktywowac rezerwacji na wycieczke, ktora miala juz miejsce.');
  END;

--c)
CREATE PROCEDURE zmien_liczbe_miejsc(id_wycieczki_arg IN INT, liczba_miejsc_arg IN INT) AS
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Niedopowiednie_Parametry EXCEPTION;
  ilosc_znalezionych           INT;
  obecna_liczba_miejsc         INT;
  obecna_liczba_wolnych_miejsc INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki WHERE ID_WYCIECZKI = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    SELECT LICZBA_MIEJSC INTO obecna_liczba_miejsc
    FROM wycieczki_miejsca wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;
    SELECT LICZBA_WOLNYCH_MIEJSC INTO obecna_liczba_wolnych_miejsc
    FROM wycieczki_miejsca wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;
    IF (liczba_miejsc_arg >= obecna_liczba_miejsc)
    THEN
      UPDATE WYCIECZKI SET LICZBA_MIEJSC = liczba_miejsc_arg WHERE ID_WYCIECZKI = id_wycieczki_arg;
    ELSE
      IF (obecna_liczba_miejsc - liczba_miejsc_arg > obecna_liczba_wolnych_miejsc)
      THEN
        RAISE Niedopowiednie_Parametry;
      ELSE
        UPDATE WYCIECZKI SET LICZBA_MIEJSC = liczba_miejsc_arg WHERE ID_WYCIECZKI = id_wycieczki_arg;
      END IF;
    END IF;
    COMMIT;
    DBMS_OUTPUT.put_line('Operacja zrealizowana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Niedopowiednie_Parametry
    THEN
      DBMS_OUTPUT.put_line(
          'Blad! Nie mozna zmniejszyc liczby miejsc na wartosc ponizej liczby zarezerwowanych miejsc.');
  END;

----------------------------------------------------------------------

-- 7 )
-- d)
CREATE VIEW wycieczki_miejsca2
  AS
    SELECT ID_WYCIECZKI, KRAJ, DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC
    FROM WYCIECZKI;
-- e)
CREATE VIEW dostepne_wycieczki2 AS
  SELECT ID_WYCIECZKI, KRAJ, DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC
  FROM WYCIECZKI
  WHERE DATA > SYSDATE
    AND LICZBA_WOLNYCH_MIEJSC > 0;

CREATE PROCEDURE przelicz AS
  obecna_liczba_wolnych_miejsc INT;
  obecna_wycieczka             INT;
  CURSOR c_wycieczki IS
    (SELECT LICZBA_MIEJSC - COUNT(r.ID_WYCIECZKI), r.ID_WYCIECZKI
     FROM REZERWACJE r
            JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
     WHERE r.STATUS != 'A'
     GROUP BY r.ID_WYCIECZKI, w.KRAJ, w.LICZBA_MIEJSC, w.NAZWA, w.DATA);
  BEGIN
    OPEN c_wycieczki;
    LOOP
      FETCH c_wycieczki INTO obecna_liczba_wolnych_miejsc, obecna_wycieczka;
      EXIT WHEN c_wycieczki%NOTFOUND;
      UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = obecna_liczba_wolnych_miejsc WHERE ID_WYCIECZKI = obecna_wycieczka;
    END LOOP;
    CLOSE c_wycieczki;
    COMMIT;
    DBMS_OUTPUT.put_line('Przywracam spojnosc danych... Gotowe.');
  END;

--d)
CREATE FUNCTION dostepne_wycieczki_fun2(kraj_arg IN STRING, data_od_arg IN DATE, data_do_arg IN DATE)
  RETURN dostepne_wycieczki_tab AS
  result dostepne_wycieczki_tab := dostepne_wycieczki_tab();
    Zly_Format_Dat EXCEPTION;
  BEGIN
    IF (data_do_arg < SYSDATE OR data_do_arg < data_od_arg)
    THEN
      RAISE Zly_Format_Dat;
    END IF;
    SELECT dostepne_wycieczki_rec(DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC)
        BULK COLLECT INTO result
    FROM dostepne_wycieczki2
    WHERE KRAJ like kraj_arg
      AND (DATA BETWEEN data_od_arg AND data_do_arg);
    RETURN result;
    EXCEPTION
    WHEN Zly_Format_Dat
    THEN
      dbms_output.put_line('Blad! Podane daty sa nieodpowiednie.');
  END;

CREATE PROCEDURE dodaj_rezerwacje2(id_wycieczki_arg IN INT, id_osoby_arg IN INT) AS
    Nie_Ma_Takiej_Osoby EXCEPTION;
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Wycieczka_Niedostepna EXCEPTION;
  ilosc_znalezionych INT;
  nowy_nr_rezerwacji INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby
    where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM dostepne_wycieczki2
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Wycieczka_Niedostepna;
    END IF;

    INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
    VALUES (id_wycieczki_arg, id_osoby_arg, 'N');
    SELECT NR_REZERWACJI INTO nowy_nr_rezerwacji
    FROM rezerwacje r
    WHERE r.ID_WYCIECZKI = id_wycieczki_arg
      AND r.ID_OSOBY = id_osoby_arg;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
    VALUES (nowy_nr_rezerwacji, SYSDATE, 'N');
    COMMIT;
    przelicz();
    dbms_output.put_line('Dokonano rezerwacji.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej osoby.');
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Wycieczka_Niedostepna
    THEN
      dbms_output.put_line('Blad! Podana wycieczka jest niedostepna.');
  END;

--b)
CREATE PROCEDURE zmien_status_rezerwacji2(id_rezerwacji_arg IN INT, status_arg IN CHAR) AS
    Nie_Ma_Takiej_Rezerwacji EXCEPTION;
    Nieprawidlowa_Operacja EXCEPTION;
    Brak_Wolnych_Miejsc EXCEPTION;
    Wycieczka_Juz_Miaja_Miejsce EXCEPTION;
  ilosc_znalezionych      INT;
  znaleziony_id_wycieczki INT;
  data_wycieczki          DATE;
  znaleziony_status       CHAR(1);
  BEGIN
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM rezerwacje
    where nr_rezerwacji = id_rezerwacji_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Rezerwacji;
    END IF;
    SELECT STATUS INTO znaleziony_status FROM rezerwacje
    WHERE NR_REZERWACJI = id_rezerwacji_arg;
    IF (znaleziony_status = status_arg)
    THEN
      RETURN;
    END IF;
    IF (status_arg NOT IN ('N', 'P', 'Z', 'A'))
    THEN
      RAISE Nieprawidlowa_Operacja;
    END IF;
    IF (znaleziony_status = 'A')
    THEN
      SELECT ID_WYCIECZKI INTO znaleziony_id_wycieczki FROM REZERWACJE
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      SELECT DATA INTO data_wycieczki FROM wycieczki w
      WHERE w.ID_WYCIECZKI = znaleziony_id_wycieczki;
      IF (data_wycieczki > SYSDATE)
      THEN
        SELECT LICZBA_WOLNYCH_MIEJSC INTO ilosc_znalezionych
        FROM wycieczki_miejsca2 dw
        WHERE dw.ID_WYCIECZKI = znaleziony_id_wycieczki;
        IF (ilosc_znalezionych > 0)
        THEN
          UPDATE REZERWACJE SET STATUS = status_arg
          WHERE NR_REZERWACJI = id_rezerwacji_arg;
          INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
          VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
        ELSE
          RAISE Brak_Wolnych_Miejsc;
        END IF;
      ELSE
        RAISE Wycieczka_Juz_Miaja_Miejsce;
      END IF;
    ELSE IF (znaleziony_status = 'N')
    THEN
      UPDATE REZERWACJE SET STATUS = status_arg
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
      VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
    ELSE IF (znaleziony_status = 'P')
    THEN
      IF (status_arg = 'N')
      THEN
        RAISE Nieprawidlowa_Operacja;
      ELSE
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
        INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
        VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
      END IF;
    ELSE IF (znaleziony_status = 'Z')
    THEN
      IF (status_arg = 'A')
      THEN
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
        INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
        VALUES (id_rezerwacji_arg, SYSDATE, status_arg);
      ELSE
        RAISE Nieprawidlowa_Operacja;
      END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    COMMIT;
    przelicz();
    dbms_output.put_line('Operacja wykonana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Rezerwacji
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej rezerwacji.');
    WHEN Nieprawidlowa_Operacja
    THEN
      DBMS_OUTPUT.put_line('Blad! Niedozwolona operacja.');
    WHEN Brak_Wolnych_Miejsc
    THEN
      DBMS_OUTPUT.put_line('Blad! Brak wolnych miejsc.');
    WHEN Wycieczka_Juz_Miaja_Miejsce
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie mozna aktywowac rezerwacji na wycieczke, ktora miala juz miejsce.');
  END;

--c)
CREATE PROCEDURE zmien_liczbe_miejsc2(id_wycieczki_arg IN INT, liczba_miejsc_arg IN INT) AS
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Niedopowiednie_Parametry EXCEPTION;
  ilosc_znalezionych           INT;
  obecna_liczba_miejsc         INT;
  obecna_liczba_wolnych_miejsc INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    WHERE ID_WYCIECZKI = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    przelicz();
    SELECT LICZBA_MIEJSC INTO obecna_liczba_miejsc
    FROM wycieczki_miejsca2 wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;
    SELECT LICZBA_WOLNYCH_MIEJSC INTO obecna_liczba_wolnych_miejsc
    FROM wycieczki_miejsca2 wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;
    IF (liczba_miejsc_arg >= obecna_liczba_miejsc)
    THEN
      UPDATE WYCIECZKI SET LICZBA_MIEJSC = liczba_miejsc_arg
      WHERE ID_WYCIECZKI = id_wycieczki_arg;
    ELSE
      IF (obecna_liczba_miejsc - liczba_miejsc_arg > obecna_liczba_wolnych_miejsc)
      THEN
        RAISE Niedopowiednie_Parametry;
      ELSE
        UPDATE WYCIECZKI SET LICZBA_MIEJSC = liczba_miejsc_arg
        WHERE ID_WYCIECZKI = id_wycieczki_arg;
      END IF;
    END IF;
    COMMIT;
    przelicz();
    DBMS_OUTPUT.put_line('Operacja zrealizowana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Niedopowiednie_Parametry
    THEN
      DBMS_OUTPUT.put_line(
          'Blad! Nie mozna zmniejszyc liczby miejsc na wartosc ponizej liczby zarezerwowanych miejsc.');
  END;

-------------------------------------------------------------------------------

-- 8)

CREATE TRIGGER dodanie_rezerwacji_log
  AFTER INSERT
  ON rezerwacje
  FOR EACH ROW
  DECLARE
    nowy_nr_rezerwacji INT;
  BEGIN
    nowy_nr_rezerwacji := :NEW.NR_REZERWACJI;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS) VALUES (nowy_nr_rezerwacji, SYSDATE, 'N');
  END;


CREATE TRIGGER zmiana_statusu_rezerwacji_log
  AFTER UPDATE
  ON rezerwacje
  FOR EACH ROW
  DECLARE
    nowy_nr_rezerwacji INT;
  BEGIN
    nowy_nr_rezerwacji := :NEW.NR_REZERWACJI;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS) VALUES (nowy_nr_rezerwacji, SYSDATE, :NEW.STATUS);
  END;

CREATE TRIGGER zabron_usuniecie_rezerwacji
  BEFORE DELETE
  ON rezerwacje
  FOR EACH ROW
  DECLARE
    wybrany_nr_rezerwacji INT;
  BEGIN
    wybrany_nr_rezerwacji := :OLD.NR_REZERWACJI;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS)
    VALUES (wybrany_nr_rezerwacji, SYSDATE, 'A');
    RAISE_APPLICATION_ERROR(-20001, 'Nie mozna usunac rezerwacji! Zmieniono status na Anulowany.');
  END;

CREATE PROCEDURE dodaj_rezerwacje3(id_wycieczki_arg IN INT, id_osoby_arg IN INT) AS
    Nie_Ma_Takiej_Osoby EXCEPTION;
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Wycieczka_Niedostepna EXCEPTION;
  ilosc_znalezionych INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby
    where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM dostepne_wycieczki2
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Wycieczka_Niedostepna;
    END IF;

    INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
    VALUES (id_wycieczki_arg, id_osoby_arg, 'N');
    COMMIT;
    przelicz();
    dbms_output.put_line('Dokonano rezerwacji.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej osoby.');
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Wycieczka_Niedostepna
    THEN
      dbms_output.put_line('Blad! Podana wycieczka jest niedostepna.');
  END;


CREATE PROCEDURE zmien_status_rezerwacji3(id_rezerwacji_arg IN INT, status_arg IN CHAR) AS
    Nie_Ma_Takiej_Rezerwacji EXCEPTION;
    Nieprawidlowa_Operacja EXCEPTION;
    Brak_Wolnych_Miejsc EXCEPTION;
    Wycieczka_Juz_Miaja_Miejsce EXCEPTION;
  ilosc_znalezionych      INT;
  znaleziony_id_wycieczki INT;
  data_wycieczki          DATE;
  znaleziony_status       CHAR(1);
  BEGIN
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM rezerwacje
    where nr_rezerwacji = id_rezerwacji_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Rezerwacji;
    END IF;
    SELECT STATUS INTO znaleziony_status FROM rezerwacje
    WHERE NR_REZERWACJI = id_rezerwacji_arg;
    IF (znaleziony_status = status_arg)
    THEN
      RETURN;
    END IF;
    IF (status_arg NOT IN ('N', 'P', 'Z', 'A'))
    THEN
      RAISE Nieprawidlowa_Operacja;
    END IF;
    IF (znaleziony_status = 'A')
    THEN
      SELECT ID_WYCIECZKI INTO znaleziony_id_wycieczki FROM REZERWACJE
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      SELECT DATA INTO data_wycieczki FROM wycieczki w
      WHERE w.ID_WYCIECZKI = znaleziony_id_wycieczki;
      IF (data_wycieczki > SYSDATE)
      THEN
        SELECT LICZBA_WOLNYCH_MIEJSC INTO ilosc_znalezionych
        FROM wycieczki_miejsca2 dw
        WHERE dw.ID_WYCIECZKI = znaleziony_id_wycieczki;
        IF (ilosc_znalezionych > 0)
        THEN
          UPDATE REZERWACJE SET STATUS = status_arg
          WHERE NR_REZERWACJI = id_rezerwacji_arg;
        ELSE
          RAISE Brak_Wolnych_Miejsc;
        END IF;
      ELSE
        RAISE Wycieczka_Juz_Miaja_Miejsce;
      END IF;
    ELSE IF (znaleziony_status = 'N')
    THEN
      UPDATE REZERWACJE SET STATUS = status_arg
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
    ELSE IF (znaleziony_status = 'P')
    THEN
      IF (status_arg = 'N')
      THEN
        RAISE Nieprawidlowa_Operacja;
      ELSE
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
      END IF;
    ELSE IF (znaleziony_status = 'Z')
    THEN
      IF (status_arg = 'A')
      THEN
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
      ELSE
        RAISE Nieprawidlowa_Operacja;
      END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    COMMIT;
    przelicz();
    dbms_output.put_line('Operacja wykonana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Rezerwacji
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej rezerwacji.');
    WHEN Nieprawidlowa_Operacja
    THEN
      DBMS_OUTPUT.put_line('Blad! Niedozwolona operacja.');
    WHEN Brak_Wolnych_Miejsc
    THEN
      DBMS_OUTPUT.put_line('Blad! Brak wolnych miejsc.');
    WHEN Wycieczka_Juz_Miaja_Miejsce
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie mozna aktywowac rezerwacji na wycieczke, ktora miala juz miejsce.');
  END;


-------------------------------------------------------------------------------

-- 9)

-- Auxillary trigger
CREATE TRIGGER dodanie_wycieczki_ustaw_wolne_miejsca
  AFTER INSERT
  ON wycieczki
  FOR EACH ROW
  BEGIN
    UPDATE wycieczki
    SET LICZBA_WOLNYCH_MIEJSC = :NEW.LICZBA_MIEJSC
    WHERE wycieczki.ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
  END;

CREATE TRIGGER dodanie_rezerwacji_odswiez_wolne_miejsca
  BEFORE INSERT
  ON rezerwacje
  FOR EACH ROW
  DECLARE
    obecna_liczba_wolnych_miejsc INT;
    znaleziony_nr_wycieczki      INT;
  BEGIN
    znaleziony_nr_wycieczki := :NEW.ID_WYCIECZKI;
    SELECT LICZBA_WOLNYCH_MIEJSC INTO obecna_liczba_wolnych_miejsc
    FROM wycieczki
    WHERE WYCIECZKI.ID_WYCIECZKI = znaleziony_nr_wycieczki;
    IF (obecna_liczba_wolnych_miejsc = 0)
    THEN
      raise_application_error(-20001, 'Blad! Brak miejsc na ta wycieczke.');
    END IF;
    UPDATE wycieczki
    SET LICZBA_WOLNYCH_MIEJSC = obecna_liczba_wolnych_miejsc - 1
    WHERE wycieczki.ID_WYCIECZKI = znaleziony_nr_wycieczki;
  END;


CREATE TRIGGER zmiana_statusu_rezerwacji_odswiez_wolne_miejsca
  AFTER UPDATE
  ON rezerwacje
  FOR EACH ROW
  DECLARE
    obecna_liczba_wolnych_miejsc INT;
    znaleziony_nr_wycieczki      INT;
  BEGIN
    znaleziony_nr_wycieczki := :NEW.ID_WYCIECZKI;
    SELECT LICZBA_WOLNYCH_MIEJSC INTO obecna_liczba_wolnych_miejsc
    FROM wycieczki
    WHERE WYCIECZKI.ID_WYCIECZKI = znaleziony_nr_wycieczki;
    IF (:NEW.STATUS = 'A' AND :OLD.STATUS != 'A')
    THEN
      UPDATE wycieczki
      SET LICZBA_WOLNYCH_MIEJSC = obecna_liczba_wolnych_miejsc + 1
      WHERE wycieczki.ID_WYCIECZKI = znaleziony_nr_wycieczki;
    END IF;
    IF (:OLD.STATUS = 'A' AND :NEW.STATUS != 'A')
    THEN
      UPDATE wycieczki
      SET LICZBA_WOLNYCH_MIEJSC = obecna_liczba_wolnych_miejsc - 1
      WHERE wycieczki.ID_WYCIECZKI = znaleziony_nr_wycieczki;
    END IF;
  END;


CREATE OR REPLACE TRIGGER zmiana_liczby_miejsc_wycieczki_sprawdz
  BEFORE UPDATE
  OF LICZBA_MIEJSC
  ON wycieczki
  FOR EACH ROW
  DECLARE
  Blad_Zajete_Miejsca EXCEPTION;
  BEGIN
    IF (:NEW.LICZBA_MIEJSC >= :OLD.LICZBA_MIEJSC)
    THEN
      GOTO allowed_operation;
    ELSE
      IF (:OLD.LICZBA_MIEJSC - :NEW.LICZBA_MIEJSC > :OLD.LICZBA_WOLNYCH_MIEJSC)
      THEN
        RAISE Blad_Zajete_Miejsca;
      END IF;
    END IF;
  <<allowed_operation>>
    dbms_output.put_line('Update liczby miejsc pomyslny');
  EXCEPTION
    WHEN Blad_Zajete_Miejsca THEN
    raise_application_error(-20001, 'Blad! Nie mozna zmniejszyc liczby miejsc, gdy sa juz zajete.');
  END;


CREATE OR REPLACE PROCEDURE zmien_liczbe_miejsc3(id_wycieczki_arg IN INT, liczba_miejsc_arg IN INT) AS
  Nie_Ma_Takiej_Wycieczki EXCEPTION;
  Niedopowiednie_Parametry EXCEPTION;
  ilosc_znalezionych           INT;
  obecna_liczba_miejsc         INT;
  obecna_liczba_wolnych_miejsc INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    WHERE ID_WYCIECZKI = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    przelicz();
    SELECT LICZBA_MIEJSC INTO obecna_liczba_miejsc
    FROM wycieczki_miejsca2 wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;
    SELECT LICZBA_WOLNYCH_MIEJSC INTO obecna_liczba_wolnych_miejsc
    FROM wycieczki_miejsca2 wm
    WHERE wm.ID_WYCIECZKI = id_wycieczki_arg;

    UPDATE WYCIECZKI SET LICZBA_MIEJSC = liczba_miejsc_arg
    WHERE ID_WYCIECZKI = id_wycieczki_arg;
    COMMIT;
    DBMS_OUTPUT.put_line('Operacja zrealizowana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej wycieczki.');
  END;

begin
  dodaj_rezerwacje4(5, 6);
end;
  select * from wycieczki;
CREATE PROCEDURE dodaj_rezerwacje4(id_wycieczki_arg IN INT, id_osoby_arg IN INT) AS
    Nie_Ma_Takiej_Osoby EXCEPTION;
    Nie_Ma_Takiej_Wycieczki EXCEPTION;
    Wycieczka_Niedostepna EXCEPTION;
  ilosc_znalezionych INT;
  BEGIN
    SELECT COUNT(*) INTO ilosc_znalezionych FROM osoby
    where id_osoby = id_osoby_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Osoby;
    END IF;
    SELECT COUNT(*) INTO ilosc_znalezionych FROM wycieczki
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Wycieczki;
    END IF;
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM dostepne_wycieczki2
    WHERE id_wycieczki = id_wycieczki_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Wycieczka_Niedostepna;
    END IF;

    INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
    VALUES (id_wycieczki_arg, id_osoby_arg, 'N');
    dbms_output.put_line('Dokonano rezerwacji.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Osoby
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej osoby.');
    WHEN Nie_Ma_Takiej_Wycieczki
    THEN
      dbms_output.put_line('Blad! Nie ma takiej wycieczki.');
    WHEN Wycieczka_Niedostepna
    THEN
      dbms_output.put_line('Blad! Podana wycieczka jest niedostepna.');
  END;

CREATE PROCEDURE zmien_status_rezerwacji4(id_rezerwacji_arg IN INT, status_arg IN CHAR) AS
    Nie_Ma_Takiej_Rezerwacji EXCEPTION;
    Nieprawidlowa_Operacja EXCEPTION;
    Brak_Wolnych_Miejsc EXCEPTION;
    Wycieczka_Juz_Miaja_Miejsce EXCEPTION;
  ilosc_znalezionych      INT;
  znaleziony_id_wycieczki INT;
  data_wycieczki          DATE;
  znaleziony_status       CHAR(1);
  BEGIN
    przelicz();
    SELECT COUNT(*) INTO ilosc_znalezionych FROM rezerwacje
    where nr_rezerwacji = id_rezerwacji_arg;
    IF (ilosc_znalezionych = 0)
    THEN
      RAISE Nie_Ma_Takiej_Rezerwacji;
    END IF;
    SELECT STATUS INTO znaleziony_status FROM rezerwacje
    WHERE NR_REZERWACJI = id_rezerwacji_arg;
    IF (znaleziony_status = status_arg)
    THEN
      RETURN;
    END IF;
    IF (status_arg NOT IN ('N', 'P', 'Z', 'A'))
    THEN
      RAISE Nieprawidlowa_Operacja;
    END IF;
    IF (znaleziony_status = 'A')
    THEN
      SELECT ID_WYCIECZKI INTO znaleziony_id_wycieczki FROM REZERWACJE
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
      SELECT DATA INTO data_wycieczki FROM wycieczki w
      WHERE w.ID_WYCIECZKI = znaleziony_id_wycieczki;
      IF (data_wycieczki > SYSDATE)
      THEN
        SELECT LICZBA_WOLNYCH_MIEJSC INTO ilosc_znalezionych
        FROM wycieczki_miejsca2 dw
        WHERE dw.ID_WYCIECZKI = znaleziony_id_wycieczki;
        IF (ilosc_znalezionych > 0)
        THEN
          UPDATE REZERWACJE SET STATUS = status_arg
          WHERE NR_REZERWACJI = id_rezerwacji_arg;
        ELSE
          RAISE Brak_Wolnych_Miejsc;
        END IF;
      ELSE
        RAISE Wycieczka_Juz_Miaja_Miejsce;
      END IF;
    ELSE IF (znaleziony_status = 'N')
    THEN
      UPDATE REZERWACJE SET STATUS = status_arg
      WHERE NR_REZERWACJI = id_rezerwacji_arg;
    ELSE IF (znaleziony_status = 'P')
    THEN
      IF (status_arg = 'N')
      THEN
        RAISE Nieprawidlowa_Operacja;
      ELSE
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
      END IF;
    ELSE IF (znaleziony_status = 'Z')
    THEN
      IF (status_arg = 'A')
      THEN
        UPDATE REZERWACJE SET STATUS = status_arg
        WHERE NR_REZERWACJI = id_rezerwacji_arg;
      ELSE
        RAISE Nieprawidlowa_Operacja;
      END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    dbms_output.put_line('Operacja wykonana pomyslnie.');
    EXCEPTION
    WHEN Nie_Ma_Takiej_Rezerwacji
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie ma takiej rezerwacji.');
    WHEN Nieprawidlowa_Operacja
    THEN
      DBMS_OUTPUT.put_line('Blad! Niedozwolona operacja.');
    WHEN Brak_Wolnych_Miejsc
    THEN
      DBMS_OUTPUT.put_line('Blad! Brak wolnych miejsc.');
    WHEN Wycieczka_Juz_Miaja_Miejsce
    THEN
      DBMS_OUTPUT.put_line('Blad! Nie mozna aktywowac rezerwacji na wycieczke, ktora miala juz miejsce.');
  END;