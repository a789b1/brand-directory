PRAGMA foreign_keys = ON;

CREATE TABLE make (name TEXT PRIMARY KEY, identification_url TEXT NOT NULL);
CREATE TABLE model (
    id TEXT PRIMARY KEY, make TEXT NOT NULL REFERENCES make(name), name TEXT NOT NULL,
    first_year INTEGER NOT NULL, last_year INTEGER NOT NULL CHECK(last_year >= first_year)
);
CREATE TABLE category (name TEXT PRIMARY KEY);
CREATE TABLE part (
    slug TEXT PRIMARY KEY, name TEXT NOT NULL, brand TEXT NOT NULL, part_number TEXT UNIQUE NOT NULL,
    category TEXT NOT NULL REFERENCES category(name), price_cents INTEGER NOT NULL CHECK(price_cents >= 0),
    retailer TEXT NOT NULL, retailer_url TEXT NOT NULL, reference_url TEXT NOT NULL,
    summary TEXT NOT NULL, description TEXT NOT NULL, fitment_note TEXT NOT NULL,
    mount TEXT NOT NULL, image_alt TEXT NOT NULL
);
CREATE TABLE fitment (
    part TEXT NOT NULL REFERENCES part(slug), model TEXT NOT NULL REFERENCES model(id),
    first_year INTEGER NOT NULL, last_year INTEGER NOT NULL CHECK(last_year >= first_year),
    PRIMARY KEY(part, model, first_year)
);
CREATE TABLE alternate_number (
    part TEXT NOT NULL REFERENCES part(slug), number TEXT NOT NULL, PRIMARY KEY(part, number)
);
CREATE TABLE specification (
    part TEXT NOT NULL REFERENCES part(slug), label TEXT NOT NULL, value TEXT NOT NULL, PRIMARY KEY(part, label)
);
CREATE TABLE installation_step (
    part TEXT NOT NULL REFERENCES part(slug), step INTEGER NOT NULL, instruction TEXT NOT NULL, PRIMARY KEY(part, step)
);

INSERT INTO make VALUES ('Club Car', 'https://www.clubcar.com/en-us/resources/club-car-model-serial-prefix');
INSERT INTO make VALUES ('E-Z-GO', 'https://ezgo.txtsv.com/personal/owners/customer-service');
INSERT INTO make VALUES ('Yamaha', 'https://yamaha-motor.com/parts/golf-car');
INSERT INTO model VALUES ('precedent', 'Club Car', 'Precedent', 2004, 2016);
INSERT INTO model VALUES ('rxv', 'E-Z-GO', 'RXV', 2008, 2023);
INSERT INTO model VALUES ('txt', 'E-Z-GO', 'TXT Gas', 2008, 2019);
INSERT INTO model VALUES ('drive', 'Yamaha', 'Drive Fleet', 2013, 2016);
INSERT INTO model VALUES ('drive2', 'Yamaha', 'Drive2 Fleet', 2017, 2020);
INSERT INTO category VALUES ('Storage & dash');
INSERT INTO category VALUES ('On-course gear');
INSERT INTO category VALUES ('Floor & trim');

INSERT INTO part VALUES ('front-cargo-basket', 'Front Cargo Basket', 'RHOX', 'ACC-BSKT04', 'Storage & dash', 43999, 'Golf Cart Garage', 'https://www.golfcartgarage.com/ezgo-rxv-golf-cart-front-cargo-basket/', 'https://redhawk.golfcart.com/pc_product_detail.asp?key=6AD2C561EECA410FAFE3D81E5F4C13B9', 'A shallow steel basket keeps loose gear up front without taking up seat space.', 'The open mesh makes small items easy to spot. A tubular rim frames the load area, and the mounting brackets are sized for the RXV front end.', 'For RXV front ends in the listed years. Check for conflicts with an existing windshield, brush guard or other front accessory.', 'Front of the cart', 'Shallow black mesh cargo basket with a tubular rim and two mounting feet');
INSERT INTO fitment VALUES ('front-cargo-basket', 'rxv', 2008, 2023);
INSERT INTO alternate_number VALUES ('front-cargo-basket', 'ACC-BSKT04');
INSERT INTO specification VALUES ('front-cargo-basket', 'Overall size', '44 × 13¼ × 4 in.');
INSERT INTO specification VALUES ('front-cargo-basket', 'Construction', 'Powder-coated steel mesh');
INSERT INTO specification VALUES ('front-cargo-basket', 'Package', 'Basket, mounting brackets and hardware');
INSERT INTO installation_step VALUES ('front-cargo-basket', 1, 'Compare the RXV model year and the front mounting points with the bracket set in the supplier listing.');
INSERT INTO installation_step VALUES ('front-cargo-basket', 2, 'With the cart parked and keyed off, position the supplied brackets and basket as directed by the kit instructions.');
INSERT INTO installation_step VALUES ('front-cargo-basket', 3, 'Before loading the basket, check the fasteners and clearance from the windshield and other accessories.');

INSERT INTO part VALUES ('locking-dash', 'Locking Dash Panel', 'MadJax', '23-001', 'Storage & dash', 24195, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/carbon-fiber-dash-for-2008-up-club-car-precedent/23-001', 'https://www.nivelparts.com/cms/files/23-001-004_Dashboard-Kit_CC-Precedent_Manual.pdf', 'Lockable compartments add enclosed storage to the Precedent dash, with a carbon-fiber-look finish.', 'This dash uses the factory trim and golf ball retainer. The manufacturer specifies a mid-2008 design change, so check the installation sheet if your cart was built during that year.', 'For the late-2008 (2008.5) dash design onward. The finder lists complete years 2009–2016. A 2008 cart needs a build-date check. Early 2008 uses a different panel.', 'Driver and passenger dash', 'Charcoal replacement dashboard with molded storage compartments and keyed doors');
INSERT INTO fitment VALUES ('locking-dash', 'precedent', 2009, 2016);
INSERT INTO alternate_number VALUES ('locking-dash', '23001');
INSERT INTO specification VALUES ('locking-dash', 'Finish', 'Carbon-fiber look');
INSERT INTO specification VALUES ('locking-dash', 'Tool called out', 'T25 Torx driver');
INSERT INTO specification VALUES ('locking-dash', 'Fitment break', 'Late 2008 dash design');
INSERT INTO installation_step VALUES ('locking-dash', 1, 'Park the cart, remove the key and compare the original dash to the drawings in the MadJax installation sheet.');
INSERT INTO installation_step VALUES ('locking-dash', 2, 'Use a T25 Torx driver to remove the original trim fasteners. Keep the factory screws for reassembly.');
INSERT INTO installation_step VALUES ('locking-dash', 3, 'Seat the new dash behind the golf ball retainer. Reinstall the original trim and fasteners as shown in the sheet, then check both doors and controls.');

INSERT INTO part VALUES ('club-ball-washer', 'Club & Ball Washer', 'Yamaha', 'GCA-JW131-01-00', 'On-course gear', 7099, 'Yamaha Motor USA', 'https://yamaha-motor.com/p/the-drive-drive2-golf-club-and-ball-washer', 'https://yamaha-motor.com/p/the-drive-drive2-golf-club-and-ball-washer', 'Separate chambers clean a club face and a golf ball in one unit that rides behind the seat.', 'The washer mounts on either side of the bag area so it can be reached between shots. Both mounting brackets and hardware are included with this part number.', 'For the standard fleet bag area. Not compatible with a rear-facing seat. An accessory already on the same side can block the washer bracket.', 'Left or right rear bag area', 'Dark molded two-chamber washer with a club brush slot and ball plunger');
INSERT INTO fitment VALUES ('club-ball-washer', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('club-ball-washer', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('club-ball-washer', 'GCAJW1310100');
INSERT INTO specification VALUES ('club-ball-washer', 'Configuration', 'Club and ball cleaning chambers');
INSERT INTO specification VALUES ('club-ball-washer', 'Hardware', 'Brackets and hardware included');
INSERT INTO specification VALUES ('club-ball-washer', 'Seat layout', 'Standard forward-facing seat');
INSERT INTO installation_step VALUES ('club-ball-washer', 1, 'Check the rear seat configuration and choose the accessible side of the golf bag area.');
INSERT INTO installation_step VALUES ('club-ball-washer', 2, 'Match the supplied bracket to the attachment points shown in the Yamaha instructions before tightening the hardware.');
INSERT INTO installation_step VALUES ('club-ball-washer', 3, 'With the unit fastened upright, check the plunger travel and clearance around the golf bags.');

INSERT INTO part VALUES ('sand-bottle', 'Handled Sand Bottle Kit', 'Yamaha', 'GCA-J0A40-00-00', 'On-course gear', 2299, 'Lets Ride Motorsports', 'https://www.lrmgolfcarts.com/shopping/item/6/yamaha-single-sand-bottle-kit', 'https://www.lrmgolfcarts.com/shopping/item/6/yamaha-single-sand-bottle-kit', 'A handled bottle with a curved spout puts divot mix within reach behind the seat.', 'The bottle lifts out of its holder for refilling or pouring. Choose the mounting side that is easiest to reach when the golf bags are loaded.', 'Requires the standard sweater basket behind the seat. Not compatible with the Yamaha rear-facing seat. Select With Handle on the retailer’s page.', 'Rear sweater basket', 'Translucent handled sand bottle with a curved spout seated in a black cart holder');
INSERT INTO fitment VALUES ('sand-bottle', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('sand-bottle', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('sand-bottle', 'GCAJ0A400000');
INSERT INTO specification VALUES ('sand-bottle', 'Bottle style', 'Single handled bottle');
INSERT INTO specification VALUES ('sand-bottle', 'Mounting side', 'Left or right');
INSERT INTO specification VALUES ('sand-bottle', 'Package', 'Bottle and holder kit');
INSERT INTO installation_step VALUES ('sand-bottle', 1, 'Check for a standard rear sweater basket and clear space on the chosen side.');
INSERT INTO installation_step VALUES ('sand-bottle', 2, 'Line up the holder behind the seatback and attach it to the basket using the kit instructions.');
INSERT INTO installation_step VALUES ('sand-bottle', 3, 'Insert the bottle, then lift it out with bags in place to check handle and spout clearance.');

INSERT INTO part VALUES ('bag-rack-strap', 'Golf Bag Rack Strap', 'Club Car fitment', '1025043-01', 'On-course gear', 2999, 'Buggies Unlimited', 'https://buggiesunlimited.com/golf-cart/bag-strap-cc-04-up-precedent-/9459', 'https://www.nivelparts.com/bag-strap-cc-04-up-precedent/p/9459', 'Replacement webbing for the rear bag hoop on a gas or electric Precedent.', 'The 76-inch strap is supplied alone. Reuse the existing compatible rack and buckle and compare the webbing width before ordering.', 'For a Precedent with its original rear bag hoop and compatible buckle. A rear-seat conversion can change the mounting arrangement.', 'Rear golf bag hoop', 'Coiled black woven golf bag strap with a square-cut loose end');
INSERT INTO fitment VALUES ('bag-rack-strap', 'precedent', 2004, 2016);
INSERT INTO alternate_number VALUES ('bag-rack-strap', '9459');
INSERT INTO alternate_number VALUES ('bag-rack-strap', '102504301');
INSERT INTO specification VALUES ('bag-rack-strap', 'Length', '76 in.');
INSERT INTO specification VALUES ('bag-rack-strap', 'Width', '1⅞ in.');
INSERT INTO specification VALUES ('bag-rack-strap', 'Supply', 'One strap, buckle sold separately');
INSERT INTO specification VALUES ('bag-rack-strap', 'Retailer item', '9459');
INSERT INTO installation_step VALUES ('bag-rack-strap', 1, 'Compare the width and length of your original webbing and inspect the rack and buckle.');
INSERT INTO installation_step VALUES ('bag-rack-strap', 2, 'Note the routing of the existing strap before removing it. Thread the replacement through the original rack and buckle in the same direction.');
INSERT INTO installation_step VALUES ('bag-rack-strap', 3, 'Pull the webbing flat and confirm the buckle holds the golf bag securely before driving.');

INSERT INTO part VALUES ('floor-mat', 'Horn-Cutout Floor Mat', 'E-Z-GO fitment', '70663-G04', 'Floor & trim', 32999, 'Buggies Unlimited', 'https://buggiesunlimited.com/golf-cart/floor-mat-whorn-cutout-ez-g-08-up-txt-5g-/50473', 'https://www.nivelparts.com/floor-mat-horn-cutout-ez-g-08-up-txt-5g/p/50473', 'A textured replacement floor mat for a gas TXT with a floor horn and four-bolt steering.', 'The cutouts follow the original footwell layout. Match the openings to the old mat and the controls before removing or installing any part.', 'Gas TXT only. Requires four-bolt steering and a floor-mounted horn. Compare the original mat pattern, even when the year matches.', 'Front footwell', 'Black molded golf cart floor mat with textured ribs and openings for the foot controls');
INSERT INTO fitment VALUES ('floor-mat', 'txt', 2008, 2019);
INSERT INTO alternate_number VALUES ('floor-mat', '50473');
INSERT INTO alternate_number VALUES ('floor-mat', '70663G04');
INSERT INTO specification VALUES ('floor-mat', 'Powertrain', 'Gasoline');
INSERT INTO specification VALUES ('floor-mat', 'Steering layout', 'Four-bolt');
INSERT INTO specification VALUES ('floor-mat', 'Horn position', 'Floor-mounted');
INSERT INTO specification VALUES ('floor-mat', 'Retailer item', '50473');
INSERT INTO installation_step VALUES ('floor-mat', 1, 'Park the cart and remove the key. Compare the replacement pattern to the original mat, including the steering, horn and pedal openings.');
INSERT INTO installation_step VALUES ('floor-mat', 2, 'Remove the old mat following the vehicle manual and seat the new mat flat in the clean footwell. Do not stack mats.');
INSERT INTO installation_step VALUES ('floor-mat', 3, 'With the cart parked, check full pedal travel and return and confirm that the mat does not interfere with any control.');
