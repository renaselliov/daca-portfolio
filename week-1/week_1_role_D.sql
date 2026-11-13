-- ALAÜLESANDE KAART D: Müügikanalid ja asukohad

-- Millised müügikanalid on olemas? 
-- Millistes kauplustes müüakse? 
-- Milliseid makseviise kasutatakse? 
-- Kas on tehinguid ilma asukoha infota?


-- Unikaalsed müügikanalid
SELECT DISTINCT channel FROM sales;

-- Unikaalsed kaupluste asukohad
SELECT DISTINCT store_location FROM sales;

-- Unikaalsed makseviisid
SELECT DISTINCT payment_method FROM sales;

-- Kanal, poe asukoht ja maksemeetod eraldiseisvatena annavad esmase info, kuid probleeme arvestades on olulisem teada saada, mida poe asukoht müügikanali puhul näitab ning kas maksemeetodid on igas müügikanalis samad.

-- Millised kanalite, asukoha ja makseviiside kombinatsioonid on andmetes?
SELECT DISTINCT channel, store_location, payment_method
FROM sales
ORDER BY channel;

-- Millised kanalid, asukohad ja makseviisid on ning mitu tehingut on tehtud ja kui paljud neist on erinevad?
SELECT channel, store_location, payment_method, COUNT(*) AS kanal_asukoht_makseviis
FROM sales
GROUP BY channel, store_location, payment_method
ORDER BY kanal_asukoht_makseviis DESC;

-- Millised kanalid, asukohad ja makseviisid on ning mitu tehingut on tehtud - distinct?
SELECT channel, store_location, payment_method, COUNT(DISTINCT sale_id) AS kanal_asukoht_makseviis_distinct
FROM sales
GROUP BY channel,store_location,  payment_method
ORDER BY kanal_asukoht_makseviis_distinct DESC;

-- Ainult müügikanalite lõikes eristuvad tehingud:
-- Millised kanalid ning mitu tehingut on tehtud ja kui paljud neist on erinevad?
SELECT channel,COUNT(*) AS kanal
FROM sales
GROUP BY channel
ORDER BY kanal DESC;

-- Millised kanalid on ning mitu tehingut on tehtud - distinct?
SELECT channel, COUNT(DISTINCT sale_id) AS kanal_distinct
FROM sales
GROUP BY channel
ORDER BY kanal_distinct DESC;

-- Ainult asukoha lõikes eristuvad tehingud:
-- Millised kanalid ning mitu tehingut on tehtud ja kui paljud neist on erinevad?
SELECT store_location, COUNT(*) AS asukoht
FROM sales
GROUP BY store_location
ORDER BY asukoht DESC;

-- Millised asukohad on ning mitu tehingut on tehtud - distinct?
SELECT store_location COUNT(DISTINCT sale_id) AS asukoht_dist
FROM sales
GROUP BY store_location
ORDER BY asukoht_dist DESC;


-- Ainult makseviisi lõikes eristuvad tehingud:
-- Millised kanalid ning mitu tehingut on tehtud ja kui paljud neist on erinevad?
SELECT payment_method, COUNT(*) AS makse
FROM sales
GROUP BY payment_method
ORDER BY makse DESC;

-- Millised asukohad on ning mitu tehingut on tehtud - distinct?
SELECT payment_method, COUNT(DISTINCT sale_id) AS makse_dist
FROM sales
GROUP BY payment_method
ORDER BY makse_dist DESC;




-- Online-müügid
SELECT * FROM sales
WHERE channel = 'online'
ORDER BY total_price DESC
LIMIT 15;

-- Tehingud ilma kaupluse asukohata
SELECT COUNT(*) AS puuduv_asukoht
FROM sales
WHERE store_location IS NULL;


-- Duplikaadid
-- Samm A: Mitu rida kokku?
SELECT COUNT(*) FROM sales;

-- Samm B: Mitu unikaalset sale_id on?
SELECT COUNT(DISTINCT sale_id) FROM sales;


-- Mis read täpselt on duplikaadid?
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY location, day, amount ORDER BY id) AS rn
  FROM sales
) t
WHERE rn > 1;

-- Neid ridu, kus kogu andmestik oleks dubleeritud, ei ole.
-- Järelikult on juhul, kui sale_id-del on duplikaadid, neil ridadel eirnev sisu ja/või osades ridades osa infot puudub.

-- Milliseid sale_id-sid on rohkem kui üks ja mitu koopiat neid on:
SELECT sale_id, COUNT(*) AS copies
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY copies DESC;



-- PUUDUVATE LAHTRITE ARVU LEIDMINE
-- Mitu customer_id on NULL?
SELECT
    COUNT(*) AS kokku,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puuduvaid
FROM sales;

SELECT
    COUNT(*) AS kokku,
    COUNT(channel) AS naitaja,
    COUNT(*) - COUNT(channel) AS puuduvaid
FROM sales;


●	Loe tehingud kokku iga kaupluse asukoha kohta:
SELECT store_location, COUNT(*) AS tehinguid
FROM sales
WHERE store_location IS NOT NULL
ORDER BY tehinguid DESC;

●	Võrdle online vs pood tehingute arvu:
-- Online-tehingute arv
SELECT COUNT(*) AS online_tehinguid
FROM sales
WHERE channel = 'online';

-- Poe-tehingute arv
SELECT COUNT(*) AS poe_tehinguid
FROM sales
WHERE channel = 'pood';
