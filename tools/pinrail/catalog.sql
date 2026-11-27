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

-- Vehicle-specific accessories and mounting requirements.
CREATE TABLE fitment_hint (
  part TEXT PRIMARY KEY REFERENCES part(slug),
  check_note TEXT NOT NULL,
  by_mount INTEGER NOT NULL DEFAULT 0 CHECK (by_mount IN (0,1))
);
INSERT INTO category VALUES ('Weather & protection');
INSERT INTO category VALUES ('Mirrors & visibility');
INSERT INTO category VALUES ('Wheels & exterior');
INSERT INTO fitment_hint VALUES ('floor-mat', 'Gas TXT · floor horn only', 0);
INSERT INTO fitment_hint VALUES ('locking-dash', 'Late-2008 dash style', 0);
INSERT INTO fitment_hint VALUES ('sand-bottle', 'Standard rear sweater basket', 0);
INSERT INTO fitment_hint VALUES ('club-ball-washer', 'Standard rear bag area only', 0);

INSERT INTO part VALUES ('rxv-folding-windshield', 'Clear Folding Windshield', 'Red Dot', '6018', 'Weather & protection', 13499, 'Buggies Unlimited', 'https://buggiesunlimited.com/golf-cart/windshield,-ez-rxv,-fd,-clear-/6018', 'https://buggiesunlimited.com/golf-cart/windshield,-ez-rxv,-fd,-clear-/6018', 'Fold the clear upper pane down for a breeze or raise it when the weather turns.', 'Two clear acrylic panels attach to the cart’s existing windshield frame. At 37¾ inches wide, the upper and lower panels share the same maximum width.', 'For the original RXV windshield frame and a dash with a raised bump on the driver’s side. The newer flat-dash RXV takes a different shield.', 'Front windshield frame', 'Clear two-piece RXV windshield with a horizontal fold line midway up the screen');
INSERT INTO fitment VALUES ('rxv-folding-windshield', 'rxv', 2008, 2023);
INSERT INTO specification VALUES ('rxv-folding-windshield', 'Material', 'Clear acrylic');
INSERT INTO specification VALUES ('rxv-folding-windshield', 'Panel thickness', '3/16 in.');
INSERT INTO specification VALUES ('rxv-folding-windshield', 'Overall height', '32.221 in., including hinge');
INSERT INTO specification VALUES ('rxv-folding-windshield', 'Maximum width', '37¾ in.');
INSERT INTO specification VALUES ('rxv-folding-windshield', 'Package', 'Folding windshield and mounting hardware');
INSERT INTO installation_step VALUES ('rxv-folding-windshield', 1, 'Look for the raised driver-side dash contour and compare the frame width with the windshield dimensions.');
INSERT INTO installation_step VALUES ('rxv-folding-windshield', 2, 'Keep the protective film on while you test the fit. Attach the supplied mounting hardware to the existing frame as shown in the windshield instructions.');
INSERT INTO installation_step VALUES ('rxv-folding-windshield', 3, 'Raise and lower the upper pane while parked. Check that it seats securely in both positions before peeling off the protective film.');
INSERT INTO fitment_hint VALUES ('rxv-folding-windshield', 'Check for the driver-side dash bump', 0);

INSERT INTO part VALUES ('rxv-front-bumper', 'RXV Front Bumper', 'Buggies Unlimited', '18-198', 'Wheels & exterior', 13099, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/front-bumper,-ez-rxv-16-up/18-198', 'https://www.buggiesunlimited.com/golf-cart/front-bumper,-ez-rxv-16-up/18-198', 'A replacement for the molded bumper below the nose of a 2016–2023 RXV.', 'This front bumper follows the shape of the original body. The supplier cross-references E-Z-GO number 656325, which is useful when replacing a damaged or missing piece.', 'Fits gas and electric RXVs with the original front body for these years. Compare attachment points if an aftermarket body or brush guard is fitted.', 'Front body, below the cowl', 'Long black molded RXV front bumper with swept ends and recessed mounting points');
INSERT INTO fitment VALUES ('rxv-front-bumper', 'rxv', 2016, 2023);
INSERT INTO alternate_number VALUES ('rxv-front-bumper', '656325');
INSERT INTO specification VALUES ('rxv-front-bumper', 'Part type', 'Replacement front bumper');
INSERT INTO specification VALUES ('rxv-front-bumper', 'Material', 'Molded plastic');
INSERT INTO specification VALUES ('rxv-front-bumper', 'OEM reference', '656325');
INSERT INTO specification VALUES ('rxv-front-bumper', 'Powertrain', 'Gas or electric');
INSERT INTO installation_step VALUES ('rxv-front-bumper', 1, 'Compare the shape and mounting positions of the old front bumper with the supplier photo.');
INSERT INTO installation_step VALUES ('rxv-front-bumper', 2, 'Park the cart on level ground and remove the existing piece using the RXV body service instructions. Check the mounts for damage before refitting.');
INSERT INTO installation_step VALUES ('rxv-front-bumper', 3, 'Align the replacement with the front body and fasten it as specified in the vehicle manual. Check its clearance around the wheels and any fitted accessories.');
INSERT INTO fitment_hint VALUES ('rxv-front-bumper', 'Stock front body', 0);

INSERT INTO part VALUES ('rxv-sweater-basket', 'Rear Sweater Basket', 'E-Z-GO', '602742', 'Storage & dash', 19995, 'Carts & Parts', 'https://carts-and-parts.com/product/oem-ezgo-rxv-golf-cart-sweater-basket-assembly-genuine-e-z-go-part-602742/', 'https://carts-and-parts.com/product/oem-ezgo-rxv-golf-cart-sweater-basket-assembly-genuine-e-z-go-part-602742/', 'An open basket behind the front bench gives a jacket or towel a place to ride above the bag well.', 'This factory replacement also carries the bag straps and buckles, so you can renew the basket and the bag restraints as one assembly.', 'Check that the original sweater-basket mounts and golf bag area remain on the cart. A rear bench or cargo conversion can replace that mounting area.', 'Behind front seat, above bag well', 'Black rear sweater basket with two golf bag straps and buckles');
INSERT INTO fitment VALUES ('rxv-sweater-basket', 'rxv', 2008, 2023);
INSERT INTO alternate_number VALUES ('rxv-sweater-basket', '7674');
INSERT INTO specification VALUES ('rxv-sweater-basket', 'Assembly', 'Original-equipment rear sweater basket');
INSERT INTO specification VALUES ('rxv-sweater-basket', 'Included', 'Basket, bag straps and buckles');
INSERT INTO specification VALUES ('rxv-sweater-basket', 'Position', 'Above the bag well');
INSERT INTO installation_step VALUES ('rxv-sweater-basket', 1, 'Empty the rear bag area and note how the old basket and straps sit behind the seat.');
INSERT INTO installation_step VALUES ('rxv-sweater-basket', 2, 'Compare the replacement mounts with the originals. Support the basket while removing the old assembly and fitting the new one to the factory supports.');
INSERT INTO installation_step VALUES ('rxv-sweater-basket', 3, 'Thread the straps around the bags and close each buckle. Check that the basket and both bags remain secure before driving.');
INSERT INTO fitment_hint VALUES ('rxv-sweater-basket', 'Requires original rear bag area', 0);

INSERT INTO part VALUES ('rxv-bag-canopy', 'Stone Beige Bag Canopy', 'E-Z-GO', '614267', 'Weather & protection', 31995, 'Carts & Parts', 'https://carts-and-parts.com/product/oem-ezgo-golf-cart-rxv-bag-cover-stone-beige-genuine-e-z-go-part-614267/', 'https://carts-and-parts.com/product/oem-ezgo-golf-cart-rxv-bag-cover-stone-beige-genuine-e-z-go-part-614267/', 'A folding rain cover shelters the golf bags behind the seat while a clear rear window keeps them in view.', 'The stone beige cover stretches over a stainless steel frame and attaches to the bag bracket. It folds away between showers.', 'Fits an RXV with the 54-inch blow-molded top and original bag bracket. The RXV modular roof uses a different cover.', 'Rear golf bag bracket', 'Stone beige folding golf bag rain canopy with a clear rear window');
INSERT INTO fitment VALUES ('rxv-bag-canopy', 'rxv', 2008, 2023);
INSERT INTO alternate_number VALUES ('rxv-bag-canopy', '604666');
INSERT INTO specification VALUES ('rxv-bag-canopy', 'Color', 'Stone beige');
INSERT INTO specification VALUES ('rxv-bag-canopy', 'Window', 'Clear vinyl');
INSERT INTO specification VALUES ('rxv-bag-canopy', 'Frame', 'Stainless steel');
INSERT INTO specification VALUES ('rxv-bag-canopy', 'Package', 'Canopy and mounting hardware');
INSERT INTO specification VALUES ('rxv-bag-canopy', 'Earlier part number', '604666');
INSERT INTO installation_step VALUES ('rxv-bag-canopy', 1, 'Verify the 54-inch blow-molded roof and check that the bag bracket is in place.');
INSERT INTO installation_step VALUES ('rxv-bag-canopy', 2, 'Attach the canopy frame to the bag bracket using the supplied hardware. The mounting arrangement does not require drilling.');
INSERT INTO installation_step VALUES ('rxv-bag-canopy', 3, 'Open the cover over the loaded bag area, check zipper access, then fold it away to check that the frame moves freely.');
INSERT INTO fitment_hint VALUES ('rxv-bag-canopy', '54-inch blow-molded top only', 0);

INSERT INTO part VALUES ('rxv-floor-liner', 'RXV All-Weather Floor Liner', 'WeatherTech', 'W603', 'Floor & trim', 11695, 'WeatherTech', 'https://www.weathertech.com/golf-cart-mat-ezgo-rxv.html?year=2018', 'https://www.weathertech.com/golf-cart-mat-ezgo-rxv.html?year=2018', 'One molded liner spans the front footwell. Raised channels carry rain and grit toward the side drains.', 'An integrated cleat cleaner scrapes grass off golf shoes. The shape follows the factory floor and holds in place without snaps or separate retainers.', 'For the front row of the 2008–2022 RXV with the original floor and floor-mounted pedals. WeatherTech lists a different part for 2023.', 'First-row footwell', 'Black molded one-piece golf cart floor liner with drainage channels and shaped pedal openings');
INSERT INTO fitment VALUES ('rxv-floor-liner', 'rxv', 2008, 2022);
INSERT INTO specification VALUES ('rxv-floor-liner', 'Material', 'Thermoplastic elastomer (TPE)');
INSERT INTO specification VALUES ('rxv-floor-liner', 'Finish', 'Black');
INSERT INTO specification VALUES ('rxv-floor-liner', 'Rows covered', 'Front only; one piece');
INSERT INTO specification VALUES ('rxv-floor-liner', 'Retention', 'Molded fit, no snaps');
INSERT INTO installation_step VALUES ('rxv-floor-liner', 1, 'Park and switch off the cart. Remove loose mats and clean the floor so the liner can seat flat.');
INSERT INTO installation_step VALUES ('rxv-floor-liner', 2, 'Follow WeatherTech’s floor-mounted-pedal installation instructions to position W603 around the controls and seat base.');
INSERT INTO installation_step VALUES ('rxv-floor-liner', 3, 'Check full pedal travel and return before driving. Keep the side drainage vents clear and remove the liner for deeper cleaning.');
INSERT INTO fitment_hint VALUES ('rxv-floor-liner', 'First row, floor-mounted pedals', 0);

INSERT INTO part VALUES ('rxv-glovebox', 'Passenger Glove Box Door', 'E-Z-GO', '607131', 'Storage & dash', 16899, 'Buggies Unlimited', 'https://buggiesunlimited.com/golf-cart/glove-box,-pass-side,-ez-rxv-2008-/7928', 'https://ezgolfcart.com/i-3598298-glove-box-door-rh-locking-rxv.html', 'Close off the open passenger-side dash cubby with a fitted, keyed door.', 'Part 607131 is the right-hand door. The opposite opening takes a different part, so identify the side from the seated driver’s perspective before ordering.', 'Fits the original passenger-side dash opening on an RXV. A custom overlay or replacement dashboard may have a different opening.', 'Passenger-side dash compartment', 'Black passenger-side dash compartment door with a small keyed latch');
INSERT INTO fitment VALUES ('rxv-glovebox', 'rxv', 2008, 2023);
INSERT INTO alternate_number VALUES ('rxv-glovebox', '7928');
INSERT INTO specification VALUES ('rxv-glovebox', 'Side', 'Right / passenger');
INSERT INTO specification VALUES ('rxv-glovebox', 'Closure', 'Keyed lock');
INSERT INTO specification VALUES ('rxv-glovebox', 'Retailer item', '7928');
INSERT INTO specification VALUES ('rxv-glovebox', 'Powertrain', 'Gas or electric');
INSERT INTO installation_step VALUES ('rxv-glovebox', 1, 'Check the passenger compartment opening and its outline against the supplier listing before removing any trim.');
INSERT INTO installation_step VALUES ('rxv-glovebox', 2, 'With the cart parked, line the door assembly up with the factory dash opening and attach it according to the RXV kit instructions.');
INSERT INTO installation_step VALUES ('rxv-glovebox', 3, 'Open and close the fitted door. Check that the latch engages and that the key turns freely before putting valuables inside.');
INSERT INTO fitment_hint VALUES ('rxv-glovebox', 'Factory dash, passenger side', 0);

INSERT INTO part VALUES ('rxv-platinum-cowl', 'Platinum Front Cowl', 'E-Z-GO fitment', '18-138', 'Wheels & exterior', 40699, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/2016-up-rxv-plat-cowl-wo-lts/18-138', 'https://parwest.com/wp-content/uploads/2024-Nivel-Golf-Course-Supply-Catalog-compressed.pdf#page=46', 'A smooth platinum front shell for an RXV that keeps its nose free of headlight openings.', 'This part replaces the front cowl alone. For a 2016-on RXV, the matching platinum rear body is sold separately under number 18-146.', 'Use on an RXV with the stock body layout when a solid panel is required. The shell arrives without light cutouts, mounting hardware or a nameplate.', 'Front body, above bumper', 'Platinum silver golf cart front cowl with a smooth nose and no headlight cutouts');
INSERT INTO fitment VALUES ('rxv-platinum-cowl', 'rxv', 2016, 2023);
INSERT INTO specification VALUES ('rxv-platinum-cowl', 'Finish', 'Platinum');
INSERT INTO specification VALUES ('rxv-platinum-cowl', 'Panel', 'Front cowl only');
INSERT INTO specification VALUES ('rxv-platinum-cowl', 'Lighting provision', 'Uncut');
INSERT INTO specification VALUES ('rxv-platinum-cowl', 'Hardware and nameplate', 'Sold separately');
INSERT INTO installation_step VALUES ('rxv-platinum-cowl', 1, 'Confirm that your cart needs an uncut nose. Compare the existing panel shape and mounting layout, particularly if lights have been added.');
INSERT INTO installation_step VALUES ('rxv-platinum-cowl', 2, 'Remove the old front shell following the RXV body service procedure. Retain serviceable fasteners and source any missing hardware or nameplate separately.');
INSERT INTO installation_step VALUES ('rxv-platinum-cowl', 3, 'Test-fit the new cowl against the bumper and side edges, then secure it using the model-specific body instructions.');
INSERT INTO fitment_hint VALUES ('rxv-platinum-cowl', 'No headlight cutouts', 0);

INSERT INTO part VALUES ('precedent-folding-windshield', 'Precedent Clear Folding Windshield', 'ProFX', 'PFX4006', 'Weather & protection', 10999, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/ProFX-Clear-Folding-Windshield-for-2004-Up-Club-Car-Precedent/PFX4006', 'https://www.buggiesunlimited.com/golf-cart/ProFX-Clear-Folding-Windshield-for-2004-Up-Club-Car-Precedent/PFX4006', 'Raise the clear upper panel for wind protection or fold it down to let air through the cab.', 'The acrylic screen fits the Precedent windshield opening. Rubber bumpers cushion the folded panel and the kit includes mounting hardware.', 'For a gas or electric Precedent with the original-style windshield opening. Measure a modified frame before ordering.', 'Front windshield frame', 'Clear two-piece acrylic golf cart windshield with rounded upper corners and a horizontal folding hinge.');
INSERT INTO fitment VALUES ('precedent-folding-windshield', 'precedent', 2004, 2016);
INSERT INTO specification VALUES ('precedent-folding-windshield', 'Screen material', '3/16 in. clear acrylic');
INSERT INTO specification VALUES ('precedent-folding-windshield', 'Width', '37.375 in.');
INSERT INTO specification VALUES ('precedent-folding-windshield', 'Overall height', '34.068 in.');
INSERT INTO specification VALUES ('precedent-folding-windshield', 'Action', 'Fold-down upper panel');
INSERT INTO installation_step VALUES ('precedent-folding-windshield', 1, 'Leave the protective film on and compare the screen width and height with the front frame.');
INSERT INTO installation_step VALUES ('precedent-folding-windshield', 2, 'Dry-fit both panels on the uprights, then attach the supplied hardware and rubber bumpers according to the kit sheet.');
INSERT INTO installation_step VALUES ('precedent-folding-windshield', 3, 'Check that the upper panel stays in place both raised and folded before removing the film.');
INSERT INTO fitment_hint VALUES ('precedent-folding-windshield', 'Original-style windshield frame', 0);

INSERT INTO part VALUES ('precedent-canopy-handle', 'Precedent White Canopy Handle', 'Club Car fitment', '1025116-01', 'Floor & trim', 2799, 'Buggies Unlimited', 'https://buggiesunlimited.com/golf-cart/2004-up-club-car-precedent-white-canopy-handle/7735', 'https://www.nivelparts.com/canopy-hle-white-club-car-2004-up/p/7735', 'A white replacement grip for the overhead handle position on a Precedent canopy.', 'Use the original handle and its mounting footprint to identify this piece. The retailer sells the handle individually under item 7735.', 'Fits gas and electric Precedents with the corresponding canopy handle mounts. Compare hole spacing on a replacement roof.', 'Overhead canopy', 'Single slim white molded golf cart roof grab handle with two mounting ends.');
INSERT INTO fitment VALUES ('precedent-canopy-handle', 'precedent', 2004, 2016);
INSERT INTO alternate_number VALUES ('precedent-canopy-handle', '7735');
INSERT INTO specification VALUES ('precedent-canopy-handle', 'Finish', 'White');
INSERT INTO specification VALUES ('precedent-canopy-handle', 'Quantity', 'One handle');
INSERT INTO specification VALUES ('precedent-canopy-handle', 'OEM cross-reference', '1025116-01');
INSERT INTO specification VALUES ('precedent-canopy-handle', 'Retailer item', '7735');
INSERT INTO installation_step VALUES ('precedent-canopy-handle', 1, 'Compare the original handle and its mounting ends with the supplier photo.');
INSERT INTO installation_step VALUES ('precedent-canopy-handle', 2, 'With the vehicle parked, remove the old handle and check that the roof mounting points are intact.');
INSERT INTO installation_step VALUES ('precedent-canopy-handle', 3, 'Position the replacement using the original mounting layout. Use the fasteners and tightening procedure specified for your canopy.');
INSERT INTO fitment_hint VALUES ('precedent-canopy-handle', 'Matching canopy handle mounts', 0);

INSERT INTO part VALUES ('precedent-seat-back', 'Precedent Beige Seat Back', 'Club Car fitment', '1025032BUFF', 'Floor & trim', 32199, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/2004-Up-Club-Car-Precedent---Beige-Seat-Back-Replacement/2939', 'https://www.buggiesunlimited.com/golf-cart/2004-Up-Club-Car-Precedent---Beige-Seat-Back-Replacement/2939', 'A complete beige front backrest replaces a worn Precedent cushion and its plastic rear cover together.', 'The backrest comes as an assembly so the original upholstery does not have to be separated from its cover. The seat bottom is a separate component.', 'For the original front bench on a Precedent. The Club Car DS has a different seat assembly, even in the same model year.', 'Front bench backrest', 'Wide beige golf cart bench backrest cushion with rounded corners, shown on its own without a seat bottom.');
INSERT INTO fitment VALUES ('precedent-seat-back', 'precedent', 2004, 2016);
INSERT INTO alternate_number VALUES ('precedent-seat-back', '2939');
INSERT INTO specification VALUES ('precedent-seat-back', 'Color', 'Beige / buff');
INSERT INTO specification VALUES ('precedent-seat-back', 'Assembly', 'Backrest and plastic rear cover');
INSERT INTO specification VALUES ('precedent-seat-back', 'Retailer item', '2939');
INSERT INTO installation_step VALUES ('precedent-seat-back', 1, 'Confirm the model and compare the original backrest shape against the supplier images.');
INSERT INTO installation_step VALUES ('precedent-seat-back', 2, 'Follow the vehicle service manual to detach the existing backrest from its supports. Retain the specified mounting hardware.');
INSERT INTO installation_step VALUES ('precedent-seat-back', 3, 'Set the complete back assembly against the matching supports and secure it to the vehicle manual’s specification before using the seat.');
INSERT INTO fitment_hint VALUES ('precedent-seat-back', 'Original Precedent front bench', 0);

INSERT INTO part VALUES ('drive-six-pack-cooler', 'Six-Pack Cart Cooler', 'Yamaha', 'GCA-JW132-02-00', 'On-course gear', 8599, 'Yamaha Motor USA', 'https://yamaha-motor.com/p/the-drive-drive2-six-pack-cooler?sku=GCA-JW132-02-00', 'https://yamaha-motor.com/p/the-drive-drive2-six-pack-cooler?sku=GCA-JW132-02-00', 'A removable hard cooler holds six drink cans or four 16.9 oz. water bottles with ice.', 'The black double-wall body has a hinged lid and a carry handle. The kit includes a bracket for the left or right side of the rear bag area.', 'Check for a standard golf bag area. The Yamaha rear-facing seat and several other basket-mounted accessories can prevent installation. See Yamaha’s compatibility list before pairing accessories.', 'Left or right rear bag area', 'Compact black molded hard-sided golf cart cooler with a flip-up lid and a carry handle.');
INSERT INTO fitment VALUES ('drive-six-pack-cooler', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('drive-six-pack-cooler', 'drive2', 2017, 2019);
INSERT INTO specification VALUES ('drive-six-pack-cooler', 'Capacity', '6 cans or 4 water bottles');
INSERT INTO specification VALUES ('drive-six-pack-cooler', 'Construction', 'Double-wall molded body');
INSERT INTO specification VALUES ('drive-six-pack-cooler', 'Package', 'Cooler, bracket and mounting hardware');
INSERT INTO installation_step VALUES ('drive-six-pack-cooler', 1, 'Check the space beside the golf bags and the list of conflicting accessories on Yamaha’s product page.');
INSERT INTO installation_step VALUES ('drive-six-pack-cooler', 2, 'Use the kit instructions to fit the bracket and hardware on the chosen side.');
INSERT INTO installation_step VALUES ('drive-six-pack-cooler', 3, 'Place the cooler in the bracket, open its lid and lift it by the handle to confirm access with bags in place.');
INSERT INTO fitment_hint VALUES ('drive-six-pack-cooler', 'Standard bag area; no rear-facing seat', 0);

INSERT INTO part VALUES ('drive-fender-flares', 'Drive Fender Flare Set', 'Yamaha', 'GCA-JP061-00-00', 'Wheels & exterior', 15899, 'Yamaha Motor USA', 'https://yamaha-motor.com/p/the-drive-fender-flare-set?sku=GCA-JP061-00-00', 'https://yamaha-motor.com/p/the-drive-fender-flare-set?sku=GCA-JP061-00-00', 'Front and rear extensions follow the wheel arches to help deflect spray, mud and loose debris.', 'The black molded flares use a profile shaped for the original Drive body. Mounting hardware is supplied with the set.', 'For first-generation Drive bodywork. Drive2 body panels have a different profile. Compare the openings if your cart has aftermarket bodywork.', 'Front and rear wheel arches', 'Set of four black curved molded golf cart wheel-arch flares, arranged separately in front and rear pairs.');
INSERT INTO fitment VALUES ('drive-fender-flares', 'drive', 2013, 2016);
INSERT INTO specification VALUES ('drive-fender-flares', 'Color', 'Black');
INSERT INTO specification VALUES ('drive-fender-flares', 'Material', 'Injection-molded plastic');
INSERT INTO specification VALUES ('drive-fender-flares', 'Coverage', 'Front and rear');
INSERT INTO specification VALUES ('drive-fender-flares', 'Hardware', 'Included');
INSERT INTO installation_step VALUES ('drive-fender-flares', 1, 'Identify the front and rear flares against the shape of each wheel opening.');
INSERT INTO installation_step VALUES ('drive-fender-flares', 2, 'Dry-fit each piece against its arch and check the body line before fastening it with the supplied hardware.');
INSERT INTO installation_step VALUES ('drive-fender-flares', 3, 'Follow the kit instructions at all mounting points, then check tire clearance on both sides before driving.');
INSERT INTO fitment_hint VALUES ('drive-fender-flares', 'Original Drive wheel arches', 0);

INSERT INTO part VALUES ('drive-kick-plate', 'Stainless Steel Kick Plate', 'Yamaha', 'GCA-JW189-00-00', 'Floor & trim', 15099, 'Yamaha Motor USA', 'https://yamaha-motor.com/p/the-drive-drive2-kick-plate?sku=GCA-JW189-00-00', 'https://yamaha-motor.com/p/the-drive-drive2-kick-plate?sku=GCA-JW189-00-00', 'A slim 38-inch stainless kick plate finishes the lower body panel with a bright metal accent.', 'Folded edges and end caps finish the ends of the strip. The kit mounts with the adhesive tape supplied by Yamaha.', 'Check Yamaha’s model listing and compare the flat mounting surface against the 38-inch plate. An altered body panel may interrupt the adhesive contact area.', 'Lower body panel', 'Long narrow satin stainless golf cart body trim strip with hemmed edges and black plastic end caps.');
INSERT INTO fitment VALUES ('drive-kick-plate', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('drive-kick-plate', 'drive2', 2017, 2020);
INSERT INTO specification VALUES ('drive-kick-plate', 'Material', 'Type 304 stainless steel');
INSERT INTO specification VALUES ('drive-kick-plate', 'Width × height', '38 × 2.67 in.');
INSERT INTO specification VALUES ('drive-kick-plate', 'Mounting', 'Supplied adhesive tape');
INSERT INTO specification VALUES ('drive-kick-plate', 'Ends', 'Plastic caps');
INSERT INTO installation_step VALUES ('drive-kick-plate', 1, 'Dry-fit the strip and both caps to the panel before exposing the tape adhesive.');
INSERT INTO installation_step VALUES ('drive-kick-plate', 2, 'Prepare the mounting surface according to Yamaha’s instructions and line up the strip with the panel.');
INSERT INTO installation_step VALUES ('drive-kick-plate', 3, 'Apply the plate with the supplied tape, seat the end caps and follow the adhesive’s instructions before washing the cart.');

INSERT INTO part VALUES ('txt-driver-rocker', 'TXT Driver-Side Rocker Panel', 'E-Z-GO fitment', '71502-G01', 'Wheels & exterior', 2899, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/1994-13-ezgo-txt-driver-side-rocker-panel/4833', 'https://www.buggiesunlimited.com/golf-cart/1994-13-ezgo-txt-driver-side-rocker-panel/4833', 'A black replacement panel finishes the lower body edge along the driver’s side of an early TXT.', 'This single left-hand rocker panel follows the sill under the driver’s entry. The opposite side uses a different molding.', 'For the pre-2014 TXT body. Verify the driver-side profile before ordering, especially if a previous owner changed the body kit.', 'Driver-side lower sill', 'Single long black molded golf cart rocker trim panel for the driver-side sill.');
INSERT INTO fitment VALUES ('txt-driver-rocker', 'txt', 2008, 2013);
INSERT INTO alternate_number VALUES ('txt-driver-rocker', '4833');
INSERT INTO specification VALUES ('txt-driver-rocker', 'Side', 'Left / driver');
INSERT INTO specification VALUES ('txt-driver-rocker', 'Material', 'Black plastic');
INSERT INTO specification VALUES ('txt-driver-rocker', 'Retailer item', '4833');
INSERT INTO installation_step VALUES ('txt-driver-rocker', 1, 'Match the original left-hand rocker shape and OEM number.');
INSERT INTO installation_step VALUES ('txt-driver-rocker', 2, 'With the cart parked, remove the worn driver-side molding as directed by the TXT body service instructions.');
INSERT INTO installation_step VALUES ('txt-driver-rocker', 3, 'Line up the replacement with the original mounting positions and secure it using the fasteners specified for the body.');
INSERT INTO fitment_hint VALUES ('txt-driver-rocker', 'Driver side; pre-2014 TXT body', 0);

INSERT INTO part VALUES ('convex-roof-mirror', '17-Inch Convex Rearview Mirror', 'GTW', '03-076', 'Mirrors & visibility', 3199, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/gtw-17-inch-convex-mirror-with-bracket/03-076', 'https://www.buggiesunlimited.com/golfcart/instructions/universal/GTW/03-076_GTW-17in-Convex-mirror-Instructions.pdf', 'A single curved mirror gives the driver a wide view across the rear of the cart.', 'Two brackets support the black-framed mirror beneath the front edge of the canopy. The GTW guide names the Precedent and the original Yamaha Drive among its applications.', 'Compare the front canopy with the mounting diagram. The 17-inch mirror needs space between the brackets, clearance above the windshield and a mounting surface suitable for the supplied screws.', 'Underside of the front canopy', 'Wide curved rearview mirror in a black frame with two mounting brackets');
INSERT INTO fitment VALUES ('convex-roof-mirror', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('convex-roof-mirror', 'drive', 2013, 2016);
INSERT INTO alternate_number VALUES ('convex-roof-mirror', '03076');
INSERT INTO specification VALUES ('convex-roof-mirror', 'Mirror width', '17 in.');
INSERT INTO specification VALUES ('convex-roof-mirror', 'Lens', 'Single convex panel');
INSERT INTO specification VALUES ('convex-roof-mirror', 'Mount', 'Two canopy brackets');
INSERT INTO installation_step VALUES ('convex-roof-mirror', 1, 'Park the cart and check headroom and windshield travel with the mirror held at the proposed location.');
INSERT INTO installation_step VALUES ('convex-roof-mirror', 2, 'Use the supplied brackets and follow the pilot-hole and screw instructions in the GTW guide for your canopy.');
INSERT INTO installation_step VALUES ('convex-roof-mirror', 3, 'From the driver’s seat, adjust the rearward view and make sure the assembly stays in position.');
INSERT INTO fitment_hint VALUES ('convex-roof-mirror', 'Requires a drillable front canopy mount', 1);

INSERT INTO part VALUES ('maverick-wheel-covers', 'Maverick 8-Inch Wheel Covers', 'GTW', 'K03-072', 'Wheels & exterior', 11199, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/set-of-(4)-8-in-gtw-maverick-chrome-and-black-wheel-covers/k03-072', 'https://www.buggiesunlimited.com/golf-cart/set-of-(4)-8-in-gtw-maverick-chrome-and-black-wheel-covers/k03-072', 'A set of four chrome-and-black wheel covers for 8-inch golf cart wheels.', 'The radial pattern finishes all four wheels in a matching design. The eight-inch measurement refers to the wheel rim. Read the last number on the tire size marking to check the rim diameter.', 'The seller specifies 8-inch golf cart wheels. Check the rim lip accepts a press-on wheel cover, especially if the cart already has aftermarket alloy wheels. A vehicle and year match alone does not confirm wheel size.', 'Outer face of each wheel', 'Four chrome-and-black wheel covers with a radial pattern');
INSERT INTO fitment VALUES ('maverick-wheel-covers', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('maverick-wheel-covers', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('maverick-wheel-covers', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('maverick-wheel-covers', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('maverick-wheel-covers', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('maverick-wheel-covers', 'K03072');
INSERT INTO specification VALUES ('maverick-wheel-covers', 'Wheel diameter', '8 in.');
INSERT INTO specification VALUES ('maverick-wheel-covers', 'Color', 'Chrome and black');
INSERT INTO specification VALUES ('maverick-wheel-covers', 'Quantity', 'Four wheel covers');
INSERT INTO installation_step VALUES ('maverick-wheel-covers', 1, 'Check all four rim diameters and inspect the retaining edge before removing the existing covers.');
INSERT INTO installation_step VALUES ('maverick-wheel-covers', 2, 'Align the cover so the tire valve remains accessible. Seat the retainer evenly around the matching rim.');
INSERT INTO installation_step VALUES ('maverick-wheel-covers', 3, 'Check that each cover sits flush and cannot be pulled loose by hand before driving.');
INSERT INTO fitment_hint VALUES ('maverick-wheel-covers', 'Requires 8-inch golf cart wheels', 1);

INSERT INTO part VALUES ('dash-beverage-tray', 'Locking Dash Organizer & Beverage Tray', 'Buggies Unlimited', '31475', 'Storage & dash', 21599, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/black-dash-organizer-and-beverage-tray/31475', 'https://www.buggiesunlimited.com/golf-cart/black-dash-organizer-and-beverage-tray/31475', 'Two large drink wells, open storage and a locking compartment share one dash tray.', 'The molded black organizer spans the front windshield supports. Small items can stay within reach while the locking compartment keeps its contents out of sight.', 'Compare the gap between the windshield struts with the tray and its brackets before drilling. Check windshield hinges, existing dash accessories and clearance above the controls.', 'Between the windshield struts', 'Long black dash tray with two cup wells and a locking storage compartment');
INSERT INTO fitment VALUES ('dash-beverage-tray', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('dash-beverage-tray', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('dash-beverage-tray', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('dash-beverage-tray', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('dash-beverage-tray', 'drive2', 2017, 2020);
INSERT INTO specification VALUES ('dash-beverage-tray', 'Material', 'Molded ABS plastic');
INSERT INTO specification VALUES ('dash-beverage-tray', 'Drink wells', 'Two oversized cupholders');
INSERT INTO specification VALUES ('dash-beverage-tray', 'Storage', 'Open compartments and locking box');
INSERT INTO specification VALUES ('dash-beverage-tray', 'Installation', 'Mounting hardware supplied, minor drilling required');
INSERT INTO installation_step VALUES ('dash-beverage-tray', 1, 'Park the cart and hold the tray between the front struts with the windshield in its normal position.');
INSERT INTO installation_step VALUES ('dash-beverage-tray', 2, 'Mark the bracket locations only after checking clearance behind the mounting surfaces. Use the supplied hardware and kit directions.');
INSERT INTO installation_step VALUES ('dash-beverage-tray', 3, 'Open the windshield and lockbox and check control access from the driver’s seat before loading the tray.');
INSERT INTO fitment_hint VALUES ('dash-beverage-tray', 'Requires accessible front windshield struts', 1);

INSERT INTO part VALUES ('roof-strut-grab-handles', 'Roof Strut Grab Handles', 'Jake’s', '53206', 'Floor & trim', 7499, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/black-grab-handle-set-(2)-/53206', 'https://www.buggiesunlimited.com/golfcart/install/Jakes/Grab-Handles/53206-Black_Grab_Handles.pdf', 'A pair of black grab handles adds a handhold on the inside of the roof supports.', 'Each handle bolts to a strut beside the passenger opening. Choose a height that leaves clearance for hands and for an enclosure or windshield already on the cart.', 'Requires roof struts that can accept the through-bolts shown in the Jake’s installation guide. Confirm the strut profile and check for wiring behind the proposed mounting points.', 'Inside faces of the roof struts', 'Pair of bent black metal grab handles with bolt-on end flanges');
INSERT INTO fitment VALUES ('roof-strut-grab-handles', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('roof-strut-grab-handles', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('roof-strut-grab-handles', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('roof-strut-grab-handles', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('roof-strut-grab-handles', 'drive2', 2017, 2020);
INSERT INTO specification VALUES ('roof-strut-grab-handles', 'Finish', 'Gloss black powder coat');
INSERT INTO specification VALUES ('roof-strut-grab-handles', 'Quantity', 'Two handles');
INSERT INTO specification VALUES ('roof-strut-grab-handles', 'Attachment', 'Bolts through roof struts');
INSERT INTO installation_step VALUES ('roof-strut-grab-handles', 1, 'Hold both handles on the inside of the roof supports and compare mounting height and hand clearance.');
INSERT INTO installation_step VALUES ('roof-strut-grab-handles', 2, 'Follow the Jake’s guide to locate and drill the mounting holes only after checking the strut is clear.');
INSERT INTO installation_step VALUES ('roof-strut-grab-handles', 3, 'Install the supplied fasteners as shown and check that each handle is secure before use.');
INSERT INTO fitment_hint VALUES ('roof-strut-grab-handles', 'Requires drillable metal roof struts', 1);

INSERT INTO part VALUES ('six-bolt-scorecard-holder', 'Six-Bolt Steering Wheel Scorecard Holder', 'MadJax', '06-019', 'On-course gear', 4399, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/aftermarket-steering-wheel-universal-score-card-holder/06-019', 'https://www.buggiesunlimited.com/golf-cart/aftermarket-steering-wheel-universal-score-card-holder/06-019', 'A clear scorecard plate keeps your card at the center of a compatible aftermarket steering wheel.', 'The 6½-by-6-inch writing surface holds a paper card where the driver can reach it between holes. Match the wheel mounting pattern and check the space around its spokes.', 'For most aftermarket steering wheels with six mounting screws. Verify the pattern and the plate’s clearance on your specific wheel, including any horn button.', 'Center of a compatible aftermarket steering wheel', 'Clear acrylic scorecard holder with a card clip for a six-bolt steering wheel');
INSERT INTO fitment VALUES ('six-bolt-scorecard-holder', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('six-bolt-scorecard-holder', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('six-bolt-scorecard-holder', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('six-bolt-scorecard-holder', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('six-bolt-scorecard-holder', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('six-bolt-scorecard-holder', '06019');
INSERT INTO specification VALUES ('six-bolt-scorecard-holder', 'Writing surface', '6½ × 6 in.');
INSERT INTO specification VALUES ('six-bolt-scorecard-holder', 'Material', 'Clear acrylic');
INSERT INTO specification VALUES ('six-bolt-scorecard-holder', 'Wheel requirement', 'Compatible aftermarket six-screw wheel');
INSERT INTO installation_step VALUES ('six-bolt-scorecard-holder', 1, 'Count the mounting screws and compare your wheel to the listing before choosing the holder.');
INSERT INTO installation_step VALUES ('six-bolt-scorecard-holder', 2, 'Check that the plate can sit flat without blocking the horn or contact with the wheel rim. Follow the hardware directions supplied with the holder.');
INSERT INTO installation_step VALUES ('six-bolt-scorecard-holder', 3, 'With the cart parked, secure a scorecard under the clip and check steering and horn clearance.');
INSERT INTO fitment_hint VALUES ('six-bolt-scorecard-holder', 'Requires a six-bolt aftermarket wheel', 1);

INSERT INTO part VALUES ('rear-seat-armrest-pair', 'Rear Seat Storage Armrests', '10L0L', 'ACC-00102-M', 'Storage & dash', 4299, '10L0L', 'https://10l0l.com/products/10l0l-all-in-one-golf-cart-rear-seat-armrest-with-storage-cup-holder-no-drill-universal-fit', 'https://10l0l.com/products/10l0l-all-in-one-golf-cart-rear-seat-armrest-with-storage-cup-holder-no-drill-universal-fit', 'Two rear seat armrests add cupholders, phone pockets and covered golf ball storage.', 'The molded arms clamp to the square side rails of a rear-facing seat kit. The removable cup inserts lift out for cleaning, and the storage lids flip up beside the passenger.', 'Requires a rear seat with square rails measuring 1 in. or 1¼ in. across the flat face. Round tubes do not accept this clamp. Check passenger and seat-folding clearance on converted carts.', 'Left and right rear-seat handrails', 'Pair of black rear seat armrests with cupholders and flip-top storage');
INSERT INTO fitment VALUES ('rear-seat-armrest-pair', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('rear-seat-armrest-pair', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('rear-seat-armrest-pair', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('rear-seat-armrest-pair', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('rear-seat-armrest-pair', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('rear-seat-armrest-pair', 'ACC00102M');
INSERT INTO specification VALUES ('rear-seat-armrest-pair', 'Rail profile', '1 or 1¼ in. square');
INSERT INTO specification VALUES ('rear-seat-armrest-pair', 'Material', 'Black ABS plastic');
INSERT INTO specification VALUES ('rear-seat-armrest-pair', 'Installation', 'Clamp-on, no drilling');
INSERT INTO specification VALUES ('rear-seat-armrest-pair', 'Package', 'Left and right armrests');
INSERT INTO installation_step VALUES ('rear-seat-armrest-pair', 1, 'Measure the rail across two parallel flat faces and confirm that both rear handrails have a straight mounting area.');
INSERT INTO installation_step VALUES ('rear-seat-armrest-pair', 2, 'Position the left and right armrests with the cupholders accessible and tighten their clamps according to the kit instructions.');
INSERT INTO installation_step VALUES ('rear-seat-armrest-pair', 3, 'Open the storage lids and check that the armrests cannot twist and that the rear seat still moves freely.');
INSERT INTO fitment_hint VALUES ('rear-seat-armrest-pair', 'Requires 1″ or 1¼″ square rear rails', 1);

INSERT INTO part VALUES ('magnetic-phone-mount', 'Magnetic Steel-Frame Phone Mount', '10L0L', 'ACC-T008-F', 'Storage & dash', 2999, '10L0L', 'https://10l0l.com/products/10l0l-magnetic-golf-cart-phone-holder-360-rotating-mount-for-iphone-android?currency=USD', 'https://10l0l.com/products/10l0l-magnetic-golf-cart-phone-holder-360-rotating-mount-for-iphone-android?currency=USD', 'A compact magnetic mount holds a compatible phone on a steel cart frame without a clamp.', 'The ball head rotates so the screen can be viewed in portrait or landscape. A supplied metal ring adapts compatible phones or cases that lack a built-in magnetic ring.', 'Test the chosen mounting area with a magnet. The base needs a flat, magnet-attracting steel surface. Aluminum, plastic and curved tubes may not hold the base. Check the phone and case together against the size and weight limits.', 'Flat magnetic steel frame or dash surface', 'Small round black magnetic phone mount with swivel joint and separate phone ring');
INSERT INTO fitment VALUES ('magnetic-phone-mount', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('magnetic-phone-mount', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('magnetic-phone-mount', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('magnetic-phone-mount', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('magnetic-phone-mount', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('magnetic-phone-mount', 'ACCT008F');
INSERT INTO specification VALUES ('magnetic-phone-mount', 'Phone weight limit', '8.5 oz.');
INSERT INTO specification VALUES ('magnetic-phone-mount', 'Maximum phone width', '3.5 in.');
INSERT INTO specification VALUES ('magnetic-phone-mount', 'Adjustment', '360° rotating head');
INSERT INTO specification VALUES ('magnetic-phone-mount', 'Adapter', 'Metal ring supplied');
INSERT INTO installation_step VALUES ('magnetic-phone-mount', 1, 'With the cart parked, verify that the base grips the chosen steel surface and that the phone clears the driver’s view and controls.');
INSERT INTO installation_step VALUES ('magnetic-phone-mount', 2, 'Use a compatible magnetic phone case or fit the supplied ring according to the seller’s directions.');
INSERT INTO installation_step VALUES ('magnetic-phone-mount', 3, 'Attach the phone, set the angle and check retention by hand before travel. Make screen adjustments while parked.');
INSERT INTO fitment_hint VALUES ('magnetic-phone-mount', 'Requires a flat magnetic steel surface', 1);

INSERT INTO part VALUES ('two-seat-storage-cover', '54-Inch Roof Storage Cover', 'Red Dot', '21-002', 'Weather & protection', 11599, 'Buggies Unlimited', 'https://www.buggiesunlimited.com/golf-cart/red-dot-cart-cover-for-2-passenger-54-top/21-002', 'https://www.madjax.com/product/?sku=21-002', 'A tan nylon storage cover slips over a parked two-passenger golf cart with a 54-inch top.', 'An elastic hem draws in around the lower body. The cover folds into its storage bag when the cart is in use.', 'Measure the roof from front to back and confirm it is 54 in. long. The cover is sized for a two-passenger cart. Extended tops, added rear seats or cargo attachments can change the required cover size.', 'Over the parked cart', 'Tan fabric storage cover fitted over a two-seat golf cart');
INSERT INTO fitment VALUES ('two-seat-storage-cover', 'precedent', 2004, 2016);
INSERT INTO fitment VALUES ('two-seat-storage-cover', 'rxv', 2008, 2023);
INSERT INTO fitment VALUES ('two-seat-storage-cover', 'txt', 2008, 2019);
INSERT INTO fitment VALUES ('two-seat-storage-cover', 'drive', 2013, 2016);
INSERT INTO fitment VALUES ('two-seat-storage-cover', 'drive2', 2017, 2020);
INSERT INTO alternate_number VALUES ('two-seat-storage-cover', '21002');
INSERT INTO specification VALUES ('two-seat-storage-cover', 'Roof length', '54 in.');
INSERT INTO specification VALUES ('two-seat-storage-cover', 'Seating layout', 'Two passengers');
INSERT INTO specification VALUES ('two-seat-storage-cover', 'Fabric', 'Tan weather-resistant nylon');
INSERT INTO specification VALUES ('two-seat-storage-cover', 'Includes', 'Cover and storage bag');
INSERT INTO installation_step VALUES ('two-seat-storage-cover', 1, 'Park the cart, switch it off and allow hot components to cool before covering.');
INSERT INTO installation_step VALUES ('two-seat-storage-cover', 2, 'Pull the cover over the top and ease the elastic hem around the body without stretching it across protruding accessories.');
INSERT INTO installation_step VALUES ('two-seat-storage-cover', 3, 'Remove the cover fully before driving. Allow it to dry before packing it into the storage bag.');
INSERT INTO fitment_hint VALUES ('two-seat-storage-cover', 'Two seats and a 54-inch roof', 1);
