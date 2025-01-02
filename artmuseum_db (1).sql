DROP DATABASE IF EXISTS ARTMUSEUM;
CREATE DATABASE ARTMUSEUM;
USE ARTMUSEUM;

DROP TABLE IF EXISTS EXHIBITION;
CREATE TABLE EXHIBITION (
    EName               VARCHAR(70) NOT NULL,
    Start_date          DATE,
    End_date            DATE,
    PRIMARY KEY (EName)
);

INSERT INTO EXHIBITION (EName, Start_date, End_date)
VALUES
('The Tudors: Art and Majesty in Renaissance England',	'2022-10-10', '2023-01-08'),
('Cubism and the Trompe l''Oeil Tradition',	'2022-10-20', '2023-01-22'),
('Hear Me Now: The Black Potters of Old Edgefield, South Carolina',	'2022-09-09', '2023-02-05'),
('Masterpiece of the Louvre',	'2022-09-30', '2023-01-05'),
('The Art of Portraiture',	'2022-10-13', '2023-02-07');

DROP TABLE IF EXISTS ARTIST;
CREATE TABLE ARTIST (
    AName               VARCHAR(60) NOT NULL,
    Date_born           INTEGER,
    Date_died           INTEGER,
    Country_of_origin   VARCHAR(20) NOT NULL,
    Main_style          VARCHAR(10) NOT NULL,
    Description         VARCHAR(300) NOT NULL,
    Epoch               VARCHAR(15) NOT NULL,
    PRIMARY KEY (AName)
);

INSERT INTO ARTIST (AName, Date_born, Date_died, Country_of_origin, Main_style, Description, Epoch)
VALUES
('Quentin Metsys The Younger',	'1543',	'1589',	'Flanders',	'Painting',	'He was a Flemish Renaissance painter, one of several of his countrymen active as artists of the Tudor court in England.',	'Renaissance'),
('Benedetto da Rovezzano',	'1474', '1552',	'Italy',	'Sculpture',	'Benedetto Grazzini, best known as Benedetto da Rovezzano was an Italian sculptor who worked mainly in Florence.',	'Renaissance'),    
('Michiel Sittow',	'1468', '1525',	'Estonia',	'Painting',	'Michael Sittow, also known as Master Michiel,  several other variants, was a painter who was trained in the tradition of Early Netherlandish painting.', 'Renaissance'),    
('Pietro Torrigiano',	'1472', '1528',	'Italy',	'Sculpture',	"Pietro Torrigiano was an Italian Renaissance sculptor from Florence, who had to flee the city after breaking Michelangelo's nose.", 'Renaissance'),
('Philippus Albericus',	'1507', '1531',	'Italy',	'Painting',	"Filippo Alberici, Tabula Cebetis, Dedicated to King Henry VII of England Second circle of Cebes's Tablet.", 'Renaissance'),    
('Juan Fernández',	'1629', '1657',	'Spain',	'Painting',	"A Spanish Mannerist painter, born at Logroño", 'Elizabeth'),    
('Pablo Picasso',	'1881', '1973',	'Spain', 'Painting',	"Pablo Ruiz Picasso was a Spanish painter, sculptor, printmaker, ceramicist and theatre designer who spent most of his adult life in France.", 'Modern'),  
('Georges Braque',	'1882', '1963',	'France', 'Painting', 'Georges Braque was a major 20th-century French painter, collagist, draughtsman, printmaker and sculptor.', 'Modern'),  
('Nicolas Glaise',	'1825',	'1888',	'France',	'Design', 'French artist',	'Victorian'),
('Adebunmi Gbadebo',	'1992',	null,	'USA',	'Multimedia','Adebunmi Gbadebo is a visual artist who creates sculptures, paintings, prints, and paper using human hair sourced from people of the African diaspora.',	'Modern'),
('Woody de Othello',	'1991',	null,	'USA',	'Sculpture','Woody De Othello is an American ceramicist and painter. He lives and works in the San Francisco Bay Area, California.',	'Modern'),
('Robert Pruitt', '1975',	null,	'USA',	'Drawing',	'Robert Pruitt is a visual artist from Houston who is known for his figurative drawings.',	'Modern'),
('Earl Robbins',	'1922',	'2010',	'USA',	'Sculpture',	'Amarican Artist', 	'Modern'),
('Simone Leigh',	'1967',	null,	'USA',	'Sculpture',	'Simone Leigh is an American artist from Chicago. She works in various media including sculpture, installations, video, performance, and social practice.',	'Modern'),
('Michelangelo',	'1475',	'1564',	'Italy',	'Sculpture',	'Michelangelo di Lodovico Buonarroti Simoni, known as Michelangelo, was an Italian sculptor, painter, architect, and poet of the High Renaissance.',	'Renaissance'),
('Leonardo Da Vinci',	'1452',	'1519',	'Italy',	'Painting',	'Leonardo di ser Piero da Vinci was an Italian polymath of the High Renaissance who was active as a painter,  and architect.',	'Renaissance'),
('Jakob Blanck',	'1906',	'1974',	'USA',	'Goldsmith',	"Jacob Nathaniel Blanck was an American bibliographer, editor, and children's writer.",	'Modern'),
('Jean-Louis Couasnon',	'1707',	'1802',	'France', 'Sculpture','Jean-Louis Couasnon was a French sculptor who specialized in portraits of living people.','Renaissance'),
('Louis-Michel van Loo',	'1707',	'1771',	'France',	'Painting',	'Louis-Michel van Loo was a French painter.','Renaissance'),
('Charles Baudelaire',	'1821',	'1867',	'France',	'Drawing',	'Charles Pierre Baudelaire was a French poet who also produced notable work as an essayist and art critic.',	'Victorian');

DROP TABLE IF EXISTS ART_OBJECT;
CREATE TABLE ART_OBJECT (
    Id_no           VARCHAR(10) NOT NULL,
    Description     VARCHAR(600) NOT NULL,
    Title           VARCHAR(100) NOT NULL,
    Origin          VARCHAR(30) NOT NULL,
    Year            INTEGER,
    Epoch           VARCHAR(15) NOT NULL,
    Style           VARCHAR(20) NOT NULL,
    E_Name          VARCHAR(70) NOT NULL,
    A_Name          VARCHAR(50),
    PRIMARY KEY (Id_no),
    FOREIGN KEY (E_Name) REFERENCES EXHIBITION(EName),
    FOREIGN KEY (A_Name) REFERENCES ARTIST(AName)
);

INSERT INTO ART_OBJECT (Id_no, Description, Title, Origin, Year, Epoch, Style, E_Name, A_Name)
VALUES
('2286', 'It is known as the ''Sieve Portrait'' because the queen holds a large sieve in her left hand which is a traditional symbol of chastity.',
'Elizabeth I (''The Sieve Portrait'')', 'Flanders', '1583', 'Elizabeth', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Quentin Metsys The Younger'),
('1350', 'Portrait of Mary Tudor', 'Mary Tudor, Later Queen of France and Duchess of Suffolk', 'Estonia', '1514',
'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Michiel Sittow'),
('1851', 'This statue represents a candle-bearing angel stepping forward, knees slightly bent, portraying a sense of movement and energy, with wavy hair adorned', 
'Angel Bearing Candlestick', 'Italy', '1524', 'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Benedetto da Rovezzano'),
('3416', 'The subject was traditionally identified as John Fisher, Bishop of Rochester and confessor to Henry VIII''s first queen, Catherine of Aragon, but the identification has been increasingly called into question.', 
'Portrait Bust of John Fisher', 'United Kingdom', '1510', 'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Pietro Torrigiano'),
('2934', 'In the sixteenth century, Chinese porcelain occasionally arrived in England, sometimes by way of the Levant, sometimes by sea around the Cape of Good Hope. As it was very rare and considered a special treasure, the most accomplished English silversmiths were often commissioned to make mounts for it. Pieces such as these were regarded as suitable for royal gifts or for the furnishing of princely houses.', 
'Ewer from Burghley House, Lincolnshire', 'China', '1573', 'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', NULL),
('1727', 'Represents the dangers and temptations that beset man and threaten to divert him from an existence predicated upon piety and study, including the study of mathematics.', 
'Tabula Cebetis, and De Mortis Effectibus', 'Italy', '1507', 'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Philippus Albericus'),
('1457', 'Candle holder', 'Candelabrum', 'Italy', '1500', 'Renaissance', 'Modern', 'The Tudors: Art and Majesty in Renaissance England', 'Benedetto da Rovezzano'),
('1388', 'Pliny the Elder''s origin story of eye-deceiving illusionism and creative competition, recounted on the wall at right, influenced artists in the Renaissance and for centuries after. Still-life painting emerged in the 1600s as a fully independent subject in European art, and grapes and curtains became popular motifs for artists aiming to vaunt their skills.', 
'Still Life with Four Bunches of Grapes', 'Spain', '1636', 'Elizabeth', 'Modern', 'Cubism and the Trompe l''Oeil Tradition', 'Juan Fernández'),
('2299', 'Bold color reentered Braque''s and Picasso''s work in spring 1912, partly in response to the Italian Futurists'' brilliantly hued canvases, which debuted in Paris earlier that year.', 
'The Scallop Shell: ''Notre Avenir est dans l''Air''', 'Spain', '1912', 'Modern', 'Abstract', 'Cubism and the Trompe l''Oeil Tradition', 'Pablo Picasso'),
('1448', 'Braque produced the first-ever Cubist papiers collés in autumn 1912 when he pasted strips of imitation wood-grain wallpaper into his drawings.', 
'Still Life with Violin', 'France', '1912', 'Modern', 'Abstract', 'Cubism and the Trompe l''Oeil Tradition', 'Georges Braque'),
('2684', 'The training of a French painter-decorator of Braque''s generation involved an apprenticeship with an established master, who introduced the novice to the specialized branches of the trade.', 
'Attributs du Peintre en Bâtiment', 'France', '1883', 'Modern', 'Modern', 'Cubism and the Trompe l''Oeil Tradition', 'Nicolas Glaise'),
('2939', '''Attributes of the Painter-Decorator'' summarizes the entire trade by depicting its essential tools and materials.', 
'Still Life', 'Spain', '1914', 'Modern', 'Modern', 'Cubism and the Trompe l''Oeil Tradition', 'Pablo Picasso'),
('3817', 'In an age when sculpture usually meant allegorical figures and portrait busts, Picasso''s life-size rendering of a glass of alcohol was shocking for its banality.', 
'The Absinthe Glass', 'Spain', '1914', 'Modern', 'Abstract', 'Cubism and the Trompe l''Oeil Tradition', 'Pablo Picasso'),
('3109', 'Rejecting traditional art materials, Gbadebo saw hair as a means to center her people and their histories as central to the narratives in her work.', 
'K.S.', 'USA', '2021', 'Modern', 'Abstract', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Adebunmi Gbadebo'),
('2661', 'Woody De Othello''s surreal clay sculptures take the shape of household objects that appear to melt, sigh, and twist themselves into knots.', 
'Applying Pressure', 'USA', '2021', 'Modern', 'Abstract', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Woody de Othello'),
('3223', 'Robert Pruitt creates large-scale drawings of Black subjects within imagined narratives that draw on elements of hip-hop culture, comic books, science fiction, and historical Black struggles.', 
'Birth and Rebirth and Rebirth', 'USA', '2019', 'Modern', 'Modern', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Robert Pruitt'),
('3572', 'Description not available', 'Cupid jug', 'USA', '2000', 'Modern', 'Modern', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Earl Robbins'),
('2968', 'Simone Leigh places modern and contemporary works by Janine Antoni, Huma Bhabha, David Hammons, and Nancy Elizabeth Prophet in the RISD Museum''s ancient Greek, Roman, and Egyptian galleries.', 
'108 (Face Jug Series)', 'USA', '2019', 'Modern', 'Abstract', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Simone Leigh'),
('2755', 'is a two-metre bronze sculpture of a woman. Her lower body is bell-shaped, evoking both a jug (with the handle) and a wide hoop skirt.', 
'Large Jug', 'USA', '2021', 'Modern', 'Abstract', 'Hear Me Now: The Black Potters of Old Edgefield, South Carolina', 'Simone Leigh'),
('4977', 'The Rebellious Slave is a 2.15m high marble statue by Michelangelo, dated to 1513. It is now held in the Louvre in Paris.', 
'Rebel Slave', 'Italy', '1513', 'Renaissance', 'Modern', 'Masterpiece of the Louvre', 'Michelangelo'),
('2422', 'The Mona Lisa is a half-length portrait painting by Italian artist Leonardo da Vinci.', 
'Portrait of Lisa Gherardini', 'Italy', '1503', 'Renaissance', 'Modern', 'Masterpiece of the Louvre', 'Leonardo Da Vinci'),
('4811', 'Description not available', 'Chest of jewels of Louis XIV', 'France', '1675', 'Elizabeth', 'Modern', 'Masterpiece of the Louvre', 'Jakob Blanck'),
('2482', 'This is the first painting publicly exhibited by François Gérard, who became one of the foremost portraitists of the period following the French Revolution.', 
'Alexandrine Émilie Brongniart', 'France', '1784', 'Enlightenment', 'Modern', 'The Art of Portraiture', 'Jean-Louis Couasnon'),
('3362', 'Denis Diderot was a French philosopher, art critic, and writer, best known for serving as co-founder.', 
'Denis Diderot', 'France', '1767', 'Enlightenment', 'Modern', 'The Art of Portraiture', 'Louis-Michel van Loo'),
('2128', 'Charles Pierre Baudelaire was a French poet who also produced notable work as an essayist and art critic.', 
'Self-Portrait', 'France', '1860', 'Victorian', 'Modern', 'The Art of Portraiture', 'Charles Baudelaire');


DROP TABLE IF EXISTS PAINTING;
CREATE TABLE PAINTING(
    item_no         varchar(10) not null,
    Paint_Type      varchar(10) not null,
    Drawn_On        varchar(10) not null,
    primary key (item_no),
    foreign key (item_no) references ART_OBJECT(Id_no)
);

INSERT INTO PAINTING(item_no, Paint_Type, Drawn_On)
VALUES
('2286','Oil','Canvas'),
('1350','Oil','Panel'),
('1727','Tempura','Parchment'),
('1388','Oil','Canvas'),
('2299','Enamel','Canvas'),
('3223','Charcoal','Panel'),
('2422','Oil','Wood'),
('3362','Oil','Canvas');

DROP TABLE IF EXISTS SCULPTURE;
CREATE TABLE SCULPTURE (
	item_no					varchar(10) not null, 
	Height					decimal,
	Weight					decimal,
    Material				varchar(15)	 not null,
	primary key (item_no),
    foreign key (item_no) references ART_OBJECT(Id_no)
);


INSERT INTO SCULPTURE (item_no, Height, Weight, Material)
VALUES
('1851','101','141','Bronze'),
('3416','61.6','28.1','Terracotta'),
('2939','25.4','5.4','Wood'),
('3817','22.5','28.6','Bronze'),
('3109','43.2','8.6','Soil'),
('2661','96.5',null,'Wood'),
('3572','27.9','26.7','Earthenware'),
('2968','44.5',null,'Porcelain'),
('2755','158.8','346.5','Stoneware'),
('4977','215','916','Marble'),
('2482','442','783.4','Marble');

DROP TABLE IF EXISTS OTHER;
CREATE TABLE OTHER (
	item_no					varchar(10) not null, 
	Type					varchar(15)	 not null,	
	primary key (item_no),
    foreign key (item_no) references ART_OBJECT(Id_no)
);


INSERT INTO OTHER (item_no, Type)
VALUES
('2934','Kitchenware'),
('1457','Metalwork'),
('1448','Collage'),
('2684','Prints'),
('4811','Artifact'),
('2128','Prints');

DROP TABLE IF EXISTS PERMANENT_COLLECTION;
CREATE TABLE PERMANENT_COLLECTION (
	item_no				VARCHAR(10) not null,
	Status				varchar(20)	not null,
	Cost				Integer,
	Date_acquired		Integer,
 
	primary key (item_no),
    foreign key (item_no) references ART_OBJECT(Id_no) 
);

INSERT INTO PERMANENT_COLLECTION (item_no, Status, Cost, Date_acquired)
VALUES
('2286', 	'Stored', '7000000', '2022'),
('1350',	'Display', 	'8000000',	'2022'),
('1851',	'Display',	'9000000',	'2022'),
('3416',	'Display',	'123000000',	'2019'),
('2934',	'Loan',	'124000000',	'2018'),
('1727',	'Display',	'124000000',	'2012'),
('1457',	'Stored',	'870000',	'2001'),
('1388',	'Loan',	'1232000',	'2012'),
('2299',	'Display',	'12140000',	'2001'),
('1448',	'Loan',	'3450810',	'2018'),
('2684',	'Stored',	'12349700',	'2019'),
('2939',	'Loan',	'18760000',	'2012'),
('3817',	'Display',	'134567900',	'2018'),
('3109',	'Stored',	'1324000',	'2001'),
('2661',	'Stored',	'120000',	'2019'),
('3223',	'Display',	'245000',	'2012'),
('3572',	'Loan',	'1000',	'2018'),
('2968',	'Display',	'30080',	'2019'),
('2755',	'Display',	'27600',	'2001');

DROP TABLE IF EXISTS COLLECTION;
CREATE TABLE COLLECTION (
    CName 						varchar(100)	not null,
    Type							varchar(10)	not null,
    Description					varchar(70)	not null,
    Address						varchar(60)	not null,
    Phone						varchar(12)	not null,
	Contact_Person				varchar(20)	not null,
	primary key (CName)
);

INSERT INTO COLLECTION (CName, Type, Description, Address, Phone, Contact_Person)
VALUES
('Department of Works of Art from the Middle Ages, The Renaissance and Modern Times',	'Museum',	'Historical Art',	'Via Partenope 59, Anitrella, Italy',	'390340500745',	'Dina Costa'),
('Department of Paintings',	'State',	'Paintings from historical and modern art within Italy.',	'Via Partenope 59, Anitrella, Italy',	'390340500745',	'Dina Costa'),
('Department of Sculptures of the Middle Ages, Renaissance and Modern Times',	'Museum',	'Historical art within France', 'Rue de Rivoli 75001 Paris, France','330101610019',	'Milun Paquet'),
('Department of Graphic Arts',	'Personal',	'Modern Art within France',	'Rue de Rivoli 75001 Paris, France','330146153905','Ozanne Rome');


DROP TABLE IF EXISTS BORROWED;
CREATE TABLE BORROWED (
	item_no						varchar(10) not null,
	Date_borrowed				varchar(20)	not null,
	Date_returned				varchar(20)	not null,
	B_CName					varchar(100)	not null,

	primary key (item_no),
    foreign key (item_no) references ART_OBJECT(Id_no),
    foreign key (B_CName) references COLLECTION(CName) 
);

INSERT INTO BORROWED (item_no, Date_borrowed, Date_returned, B_CName)
VALUES
('4977',	'2019-03-04',	'2022-12-01',	'Department of Works of Art from the Middle Ages, The Renaissance and Modern Times'),
('2422',	'2019-03-05',	'2022-12-02',	'Department of Paintings'),
('4811',	'2019-03-06',	'2022-12-03',	'Department of Works of Art from the Middle Ages, The Renaissance and Modern Times'),
('2482',	'2020-09-30',	'2022-11-30',	'Department of Sculptures of the Middle Ages, Renaissance and Modern Times'),
('3362',	'2020-10-01',	'2022-12-01',	'Department of Paintings'),
('2128',	'2020-10-02',	'2022-12-02',	'Department of Graphic Arts');

CREATE TABLE users (
    username        VARCHAR(50) UNIQUE NOT NULL,
    password        VARCHAR(255) NOT NULL,
    role            ENUM('admin', 'data_entry', 'end_user') NOT NULL,
    block_status    BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (username)
);

-- Insert data into the users table
INSERT INTO users (username, password, role, block_status)
VALUES 
    ('admin', 'password', 'admin', FALSE),
    ('data_user', 'password', 'data_entry', FALSE),
    ('end_user', 'password', 'end_user', FALSE);