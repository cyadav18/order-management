-- SEQUENCES --
CREATE SEQUENCE IF NOT EXISTS countries_seq;

-- TABLES --

CREATE TABLE IF NOT EXISTS roles (
    id SERIAL NOT NULL,
    role_name VARCHAR(255) NOT NULL,
    privileges TEXT [],
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS staff_accounts (
     id BIGSERIAL NOT NULL,
     role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(100) DEFAULT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    image TEXT DEFAULT NULL,
    placeholder TEXT DEFAULT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS categories (
 id BIGSERIAL NOT NULL,
 parent_id BIGINT REFERENCES categories (id) ON DELETE SET NULL,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    category_description TEXT,
    icon TEXT,
    image TEXT,
    placeholder TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS products (
      id BIGSERIAL NOT NULL,
      slug TEXT NOT NULL UNIQUE,
      product_name VARCHAR(255) NOT NULL,
    sku VARCHAR(255),
    sale_price NUMERIC NOT NULL DEFAULT 0,
    compare_price NUMERIC DEFAULT 0,
    buying_price NUMERIC DEFAULT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    short_description VARCHAR(165) NOT NULL,
    product_description TEXT NOT NULL,
    product_type VARCHAR(64) CHECK (product_type IN ('simple', 'variable')),
    published BOOLEAN DEFAULT FALSE,
    disable_out_of_stock BOOLEAN DEFAULT TRUE,
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    CHECK (compare_price > sale_price OR compare_price = 0),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_categories (
         id BIGSERIAL NOT NULL,
         product_id BIGINT REFERENCES products(id) NOT NULL,
    category_id BIGINT REFERENCES categories(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_shipping_info (
    id BIGSERIAL NOT NULL,
    product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
    weight NUMERIC NOT NULL DEFAULT 0,
    weight_unit VARCHAR(10) CHECK (weight_unit IN ('g', 'kg')),
    volume NUMERIC NOT NULL DEFAULT 0,
    volume_unit VARCHAR(10) CHECK (volume_unit IN ('l', 'ml')),
    dimension_width NUMERIC NOT NULL DEFAULT 0,
    dimension_height NUMERIC NOT NULL DEFAULT 0,
    dimension_depth NUMERIC NOT NULL DEFAULT 0,
    dimension_unit VARCHAR(10) CHECK (dimension_unit IN ('l', 'ml','cm')),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS gallery (
    id BIGSERIAL NOT NULL,
    product_id BIGINT REFERENCES products(id),
    image TEXT NOT NULL,
    placeholder TEXT NOT NULL,
    is_thumbnail BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
    ) PARTITION BY HASH(id);

CREATE TABLE IF NOT EXISTS attributes (
 id BIGSERIAL NOT NULL,
 attribute_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS attribute_values (
    id BIGSERIAL NOT NULL,
    attribute_id BIGINT REFERENCES attributes(id) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL,
    color VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_attributes (
    id BIGSERIAL NOT NULL,
    product_id BIGINT REFERENCES products(id) NOT NULL,
    attribute_id BIGINT REFERENCES attributes(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_attribute_values (
    id BIGSERIAL NOT NULL,
    product_attribute_id BIGINT REFERENCES product_attributes(id) NOT NULL,
    attribute_value_id BIGINT REFERENCES attribute_values(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS variant_options (
    id BIGSERIAL NOT NULL,
    title TEXT NOT NULL,
    image_id BIGINT REFERENCES gallery(id) ON DELETE SET NULL,
    product_id BIGINT REFERENCES products(id) NOT NULL,
    sale_price NUMERIC NOT NULL DEFAULT 0,
    compare_price NUMERIC DEFAULT 0,
    buying_price NUMERIC DEFAULT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    sku VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    CHECK (compare_price > sale_price OR compare_price = 0),
    PRIMARY KEY (id)
    );

-- Means a product has 2 variants black/XL red/XL
CREATE TABLE IF NOT EXISTS variants (
      id BIGSERIAL NOT NULL,
      variant_option TEXT NOT NULL,
      product_id BIGINT REFERENCES products(id) NOT NULL,
    variant_option_id BIGINT REFERENCES variant_options(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS variant_values (
     id BIGSERIAL NOT NULL,
     variant_id BIGINT REFERENCES variants(id) NOT NULL,
    product_attribute_value_id BIGINT REFERENCES product_attribute_values(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS customers (
id BIGSERIAL NOT NULL,
first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS customer_addresses (
         id BIGSERIAL NOT NULL,
         customer_id BIGINT REFERENCES customers(id),
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    phone_number VARCHAR(255) NOT NULL,
    dial_code VARCHAR(100) NOT NULL,
    country VARCHAR(255) NOT NULL,
    postal_code VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS coupons (
     id BIGSERIAL NOT NULL,
     code VARCHAR(50) NOT NULL UNIQUE,
    discount_value NUMERIC,
    discount_type VARCHAR(50) NOT NULL,
    times_used NUMERIC NOT NULL DEFAULT 0,
    max_usage NUMERIC DEFAULT null,
    order_amount_limit NUMERIC DEFAULT null,
    coupon_start_date TIMESTAMPTZ,
    coupon_end_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_coupons (
      id BIGSERIAL NOT NULL,
      product_id BIGINT REFERENCES products(id) NOT NULL,
    coupon_id BIGINT REFERENCES coupons(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS countries (
    id INT NOT NULL DEFAULT NEXTVAL ('countries_seq'),
    iso CHAR(2) NOT NULL,
    name VARCHAR(80) NOT NULL,
    upper_name VARCHAR(80) NOT NULL,
    iso3 CHAR(3) DEFAULT NULL,
    num_code SMALLINT DEFAULT NULL,
    phone_code INT NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS shipping_zones (
     id SERIAL NOT NULL,
     name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    active BOOLEAN DEFAULT FALSE,
    free_shipping BOOLEAN DEFAULT FALSE,
    rate_type VARCHAR(64) CHECK (rate_type IN ('price', 'weight')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS shipping_country_zones (
             id BIGSERIAL NOT NULL,
             shipping_zone_id INTEGER REFERENCES shipping_zones(id) NOT NULL,
    country_id INTEGER REFERENCES countries(id) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS shipping_rates (
    id BIGSERIAL NOT NULL,
    shipping_zone_id INTEGER REFERENCES shipping_zones(id) NOT NULL,
    weight_unit VARCHAR(10) CHECK (weight_unit IN ('g', 'kg')),
    min_value NUMERIC NOT NULL DEFAULT 0,
    max_value NUMERIC DEFAULT NULL,
    no_max BOOLEAN DEFAULT TRUE,
    price NUMERIC NOT NULL DEFAULT 0,
    CHECK (max_value > min_value OR no_max IS TRUE),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS order_statuses (
    id BIGSERIAL NOT NULL,
    status_name VARCHAR(255) NOT NULL,
    color VARCHAR(50) NOT NULL,
    privacy VARCHAR(10) CHECK (privacy IN ('public', 'private')) NOT NULL DEFAULT 'private',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(50) NOT NULL,
    coupon_id BIGINT REFERENCES coupons(id) ON DELETE SET NULL,
    customer_id BIGINT REFERENCES customers(id),
    order_status_id BIGINT REFERENCES order_statuses(id) ON DELETE SET NULL,
    order_approved_at TIMESTAMPTZ,
    order_delivered_carrier_date TIMESTAMPTZ,
    order_delivered_customer_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id) -- It's better to use Two-Phase Locking inside your transaction (SELECT ... FOR UPDATE) to prevent double booking problems for this table.
    );

CREATE TABLE IF NOT EXISTS order_items (
  id BIGSERIAL NOT NULL,
  product_id BIGINT REFERENCES products(id),
    order_id VARCHAR(50) REFERENCES orders(id),
    price NUMERIC NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS sells (
   id SERIAL NOT NULL,
   product_id BIGINT UNIQUE REFERENCES products(id),
    price NUMERIC NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS slideshows (
 id BIGSERIAL NOT NULL,
 title VARCHAR(80),
    destination_url TEXT,
    image TEXT NOT NULL,
    placeholder TEXT NOT NULL,
    description VARCHAR(160),
    btn_label VARCHAR(50),
    display_order INTEGER NOT NULL,
    published BOOLEAN DEFAULT FALSE,
    clicks INTEGER NOT NULL DEFAULT 0,
    styles JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL NOT NULL,
    account_id BIGINT REFERENCES staff_accounts(id),
    title VARCHAR(100),
    content TEXT,
    seen BOOLEAN,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    receive_time TIMESTAMPTZ,
    notification_expiry_date DATE,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS carts (
    id BIGSERIAL NOT NULL,
    customer_id BIGINT REFERENCES customers(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS cart_items (
    id BIGSERIAL NOT NULL,
    cart_id BIGINT REFERENCES carts(id),
    product_id BIGINT REFERENCES products(id),
    quantity INTEGER DEFAULT 1,
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS tags (
    id BIGSERIAL NOT NULL,
    tag_name VARCHAR(255) NOT NULL,
    icon TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_tags (
    tag_id BIGINT REFERENCES tags(id) NOT NULL,
    product_id BIGINT REFERENCES products(id) NOT NULL,
    PRIMARY KEY (tag_id, product_id)
    );

CREATE TABLE IF NOT EXISTS suppliers (
id BIGSERIAL NOT NULL,
supplier_name VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    phone_number VARCHAR(255),
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    country_id INTEGER REFERENCES countries(id) NOT NULL,
    city VARCHAR(255),
    note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by BIGINT REFERENCES staff_accounts(id),
    updated_by BIGINT REFERENCES staff_accounts(id),
    PRIMARY KEY (id)
    );

CREATE TABLE IF NOT EXISTS product_suppliers (
    product_id BIGINT REFERENCES products(id) NOT NULL,
    supplier_id BIGINT REFERENCES suppliers(id) NOT NULL,
    PRIMARY KEY (product_id, supplier_id)
    );


WITH att_id AS ( INSERT INTO attributes (attribute_name) VALUES ('Color'), ('Size') RETURNING * )
INSERT INTO attribute_values (attribute_id, attribute_value, color) VALUES
    (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'black', '#000'),
    (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'white', '#FFF'),
    (( SELECT id FROM att_id WHERE attribute_name = 'Color'), 'red', '#FF0000'),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'), 'S', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'), 'M', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'L', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'XL', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'2XL', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'3XL', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'),'4XL', null),
    (( SELECT id FROM att_id WHERE attribute_name = 'Size'), '5XL', null);

INSERT INTO order_statuses (status_name, color, privacy) VALUES
('Delivered', '#5ae510','public'),
('Unreached', '#ff03d3','public'),
('Paid', '#4caf50','public'),
('Confirmed', '#00d4cb','public'),
('Processing', '#ab5ae9', 'public'),
('Pending', '#ffe224', 'public'),
('On Hold', '#d6d6d6', 'public'),
('Shipped', '#71f9f7', 'public'),
('Cancelled', '#FD9F3D', 'public'),
('Refused', '#FF532F', 'private'),
('Awaiting Return', '#000', 'private'),
('Returned', '#000', 'private');

INSERT INTO roles (id, role_name, privileges) VALUES
(1, 'Store Administrator', ARRAY ['super_admin_privilege', 'admin_read_privilege', 'admin_create_privilege', 'admin_update_privilege', 'admin_delete_privilege', 'staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
(2, 'Sales Manager', ARRAY ['admin_read_privilege', 'admin_create_privilege', 'admin_update_privilege', 'admin_delete_privilege', 'staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
(3, 'Sales Staff', ARRAY ['staff_read_privilege', 'staff_create_privilege', 'staff_update_privilege', 'staff_delete_privilege']),
(4, 'Guest', ARRAY ['staff_read_privilege']),
(5, 'Investor', ARRAY ['admin_read_privilege', 'staff_read_privilege']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Super Admin', ARRAY ['read', 'write', 'delete']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Admin', ARRAY ['read', 'write']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Manager', ARRAY ['read', 'write']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Editor', ARRAY ['read', 'write']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Customer Support', ARRAY ['read']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Sales', ARRAY ['read']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Shipping', ARRAY ['read']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Marketing', ARRAY ['read', 'write']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Analytics', ARRAY ['read']);
-- INSERT INTO roles (role_name, privileges) VALUES ('Intern', ARRAY ['read']);

INSERT INTO tags (tag_name, icon) VALUES
( 'Tools', 'Tools'),
( 'Beauty Health', 'BeautyHealth'),
( 'Shirts', 'Shirts'),
( 'Accessories', 'Accessories');


INSERT INTO countries (id, iso, upper_name, name, iso3, num_code, phone_code) VALUES
(1, 'AF', 'AFGHANISTAN', 'Afghanistan', 'AFG', 4, 93),
(2, 'AL', 'ALBANIA', 'Albania', 'ALB', 8, 355),
(3, 'DZ', 'ALGERIA', 'Algeria', 'DZA', 12, 213),
(4, 'AS', 'AMERICAN SAMOA', 'American Samoa', 'ASM', 16, 1684),
(5, 'AD', 'ANDORRA', 'Andorra', 'AND', 20, 376),
(6, 'AO', 'ANGOLA', 'Angola', 'AGO', 24, 244),
(7, 'AI', 'ANGUILLA', 'Anguilla', 'AIA', 660, 1264),
(8, 'AQ', 'ANTARCTICA', 'Antarctica', 'ATA', 10, 0),
(9, 'AG', 'ANTIGUA AND BARBUDA', 'Antigua and Barbuda', 'ATG', 28, 1268),
(10, 'AR', 'ARGENTINA', 'Argentina', 'ARG', 32, 54),
(11, 'AM', 'ARMENIA', 'Armenia', 'ARM', 51, 374),
(12, 'AW', 'ARUBA', 'Aruba', 'ABW', 533, 297),
(13, 'AU', 'AUSTRALIA', 'Australia', 'AUS', 36, 61),
(14, 'AT', 'AUSTRIA', 'Austria', 'AUT', 40, 43),
(15, 'AZ', 'AZERBAIJAN', 'Azerbaijan', 'AZE', 31, 994),
(16, 'BS', 'BAHAMAS', 'Bahamas', 'BHS', 44, 1242),
(17, 'BH', 'BAHRAIN', 'Bahrain', 'BHR', 48, 973),
(18, 'BD', 'BANGLADESH', 'Bangladesh', 'BGD', 50, 880),
(19, 'BB', 'BARBADOS', 'Barbados', 'BRB', 52, 1246),
(20, 'BY', 'BELARUS', 'Belarus', 'BLR', 112, 375),
(21, 'BE', 'BELGIUM', 'Belgium', 'BEL', 56, 32),
(22, 'BZ', 'BELIZE', 'Belize', 'BLZ', 84, 501),
(23, 'BJ', 'BENIN', 'Benin', 'BEN', 204, 229),
(24, 'BM', 'BERMUDA', 'Bermuda', 'BMU', 60, 1441),
(25, 'BT', 'BHUTAN', 'Bhutan', 'BTN', 64, 975),
(26, 'BO', 'BOLIVIA', 'Bolivia', 'BOL', 68, 591),
(27, 'BA', 'BOSNIA AND HERZEGOVINA', 'Bosnia and Herzegovina', 'BIH', 70, 387),
(28, 'BW', 'BOTSWANA', 'Botswana', 'BWA', 72, 267),
(29, 'BV', 'BOUVET ISLAND', 'Bouvet Island', 'BVT', 74, 0),
(30, 'BR', 'BRAZIL', 'Brazil', 'BRA', 76, 55),
(31, 'IO', 'BRITISH INDIAN OCEAN TERRITORY', 'British Indian Ocean Territory', 'IOT', 86, 246),
(32, 'BN', 'BRUNEI DARUSSALAM', 'Brunei Darussalam', 'BRN', 96, 673),
(33, 'BG', 'BULGARIA', 'Bulgaria', 'BGR', 100, 359),
(34, 'BF', 'BURKINA FASO', 'Burkina Faso', 'BFA', 854, 226),
(35, 'BI', 'BURUNDI', 'Burundi', 'BDI', 108, 257),
(36, 'KH', 'CAMBODIA', 'Cambodia', 'KHM', 116, 855),
(37, 'CM', 'CAMEROON', 'Cameroon', 'CMR', 120, 237),
(38, 'CA', 'CANADA', 'Canada', 'CAN', 124, 1),
(39, 'CV', 'CAPE VERDE', 'Cape Verde', 'CPV', 132, 238),
(40, 'KY', 'CAYMAN ISLANDS', 'Cayman Islands', 'CYM', 136, 1345),
(41, 'CF', 'CENTRAL AFRICAN REPUBLIC', 'Central African Republic', 'CAF', 140, 236),
(42, 'TD', 'CHAD', 'Chad', 'TCD', 148, 235),
(43, 'CL', 'CHILE', 'Chile', 'CHL', 152, 56),
(44, 'CN', 'CHINA', 'China', 'CHN', 156, 86),
(45, 'CX', 'CHRISTMAS ISLAND', 'Christmas Island', 'CXR', 162, 61),
(46, 'CC', 'COCOS (KEELING) ISLANDS', 'Cocos (Keeling) Islands', NULL, NULL, 672),
(47, 'CO', 'COLOMBIA', 'Colombia', 'COL', 170, 57),
(48, 'KM', 'COMOROS', 'Comoros', 'COM', 174, 269),
(49, 'CG', 'CONGO', 'Congo', 'COG', 178, 242),
(50, 'CD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'Congo, the Democratic Republic of the', 'COD', 180, 242),
(51, 'CK', 'COOK ISLANDS', 'Cook Islands', 'COK', 184, 682),
(52, 'CR', 'COSTA RICA', 'Costa Rica', 'CRI', 188, 506),
(53, 'CI', 'COTE D''IVOIRE', 'Cote D''Ivoire', 'CIV', 384, 225),
(54, 'HR', 'CROATIA', 'Croatia', 'HRV', 191, 385),
(55, 'CU', 'CUBA', 'Cuba', 'CUB', 192, 53),
(56, 'CY', 'CYPRUS', 'Cyprus', 'CYP', 196, 357),
(57, 'CZ', 'CZECHIA', 'Czech Republic', 'CZE', 203, 420),
(58, 'DK', 'DENMARK', 'Denmark', 'DNK', 208, 45),
(59, 'DJ', 'DJIBOUTI', 'Djibouti', 'DJI', 262, 253),
(60, 'DM', 'DOMINICA', 'Dominica', 'DMA', 212, 1767),
(61, 'DO', 'DOMINICAN REPUBLIC', 'Dominican Republic', 'DOM', 214, 1),
(62, 'EC', 'ECUADOR', 'Ecuador', 'ECU', 218, 593),
(63, 'EG', 'EGYPT', 'Egypt', 'EGY', 818, 20),
(64, 'SV', 'EL SALVADOR', 'El Salvador', 'SLV', 222, 503),
(65, 'GQ', 'EQUATORIAL GUINEA', 'Equatorial Guinea', 'GNQ', 226, 240),
(66, 'ER', 'ERITREA', 'Eritrea', 'ERI', 232, 291),
(67, 'EE', 'ESTONIA', 'Estonia', 'EST', 233, 372),
(68, 'ET', 'ETHIOPIA', 'Ethiopia', 'ETH', 231, 251),
(69, 'FK', 'FALKLAND ISLANDS (MALVINAS)', 'Falkland Islands (Malvinas)', 'FLK', 238, 500),
(70, 'FO', 'FAROE ISLANDS', 'Faroe Islands', 'FRO', 234, 298),
(71, 'FJ', 'FIJI', 'Fiji', 'FJI', 242, 679),
(72, 'FI', 'FINLAND', 'Finland', 'FIN', 246, 358),
(73, 'FR', 'FRANCE', 'France', 'FRA', 250, 33),
(74, 'GF', 'FRENCH GUIANA', 'French Guiana', 'GUF', 254, 594),
(75, 'PF', 'FRENCH POLYNESIA', 'French Polynesia', 'PYF', 258, 689),
(76, 'TF', 'FRENCH SOUTHERN TERRITORIES', 'French Southern Territories', 'ATF', 260, 0),
(77, 'GA', 'GABON', 'Gabon', 'GAB', 266, 241),
(78, 'GM', 'GAMBIA', 'Gambia', 'GMB', 270, 220),
(79, 'GE', 'GEORGIA', 'Georgia', 'GEO', 268, 995),
(80, 'DE', 'GERMANY', 'Germany', 'DEU', 276, 49),
(81, 'GH', 'GHANA', 'Ghana', 'GHA', 288, 233),
(82, 'GI', 'GIBRALTAR', 'Gibraltar', 'GIB', 292, 350),
(83, 'GR', 'GREECE', 'Greece', 'GRC', 300, 30),
(84, 'GL', 'GREENLAND', 'Greenland', 'GRL', 304, 299),
(85, 'GD', 'GRENADA', 'Grenada', 'GRD', 308, 1473),
(86, 'GP', 'GUADELOUPE', 'Guadeloupe', 'GLP', 312, 590),
(87, 'GU', 'GUAM', 'Guam', 'GUM', 316, 1671),
(88, 'GT', 'GUATEMALA', 'Guatemala', 'GTM', 320, 502),
(89, 'GN', 'GUINEA', 'Guinea', 'GIN', 324, 224),
(90, 'GW', 'GUINEA-BISSAU', 'Guinea-Bissau', 'GNB', 624, 245),
(91, 'GY', 'GUYANA', 'Guyana', 'GUY', 328, 592),
(92, 'HT', 'HAITI', 'Haiti', 'HTI', 332, 509),
(93, 'HM', 'HEARD ISLAND AND MCDONALD ISLANDS', 'Heard Island and Mcdonald Islands', 'HMD', 334, 0),
(94, 'VA', 'HOLY SEE (VATICAN CITY STATE)', 'Holy See (Vatican City State)', 'VAT', 336, 39),
(95, 'HN', 'HONDURAS', 'Honduras', 'HND', 340, 504),
(96, 'HK', 'HONG KONG', 'Hong Kong', 'HKG', 344, 852),
(97, 'HU', 'HUNGARY', 'Hungary', 'HUN', 348, 36),
(98, 'IS', 'ICELAND', 'Iceland', 'ISL', 352, 354),
(99, 'IN', 'INDIA', 'India', 'IND', 356, 91),
(100, 'ID', 'INDONESIA', 'Indonesia', 'IDN', 360, 62),
(101, 'IR', 'IRAN, ISLAMIC REPUBLIC OF', 'Iran, Islamic Republic of', 'IRN', 364, 98),
(102, 'IQ', 'IRAQ', 'Iraq', 'IRQ', 368, 964),
(103, 'IE', 'IRELAND', 'Ireland', 'IRL', 372, 353),
(104, 'IL', 'ISRAEL', 'Israel', 'ISR', 376, 972),
(105, 'IT', 'ITALY', 'Italy', 'ITA', 380, 39),
(106, 'JM', 'JAMAICA', 'Jamaica', 'JAM', 388, 1876),
(107, 'JP', 'JAPAN', 'Japan', 'JPN', 392, 81),
(108, 'JO', 'JORDAN', 'Jordan', 'JOR', 400, 962),
(109, 'KZ', 'KAZAKHSTAN', 'Kazakhstan', 'KAZ', 398, 7),
(110, 'KE', 'KENYA', 'Kenya', 'KEN', 404, 254),
(111, 'KI', 'KIRIBATI', 'Kiribati', 'KIR', 296, 686),
(112, 'KP', 'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', 'Korea, Democratic People''s Republic of', 'PRK', 408, 850),
(113, 'KR', 'KOREA, REPUBLIC OF', 'Korea, Republic of', 'KOR', 410, 82),
(114, 'KW', 'KUWAIT', 'Kuwait', 'KWT', 414, 965),
(115, 'KG', 'KYRGYZSTAN', 'Kyrgyzstan', 'KGZ', 417, 996),
(116, 'LA', 'LAO PEOPLE''S DEMOCRATIC REPUBLIC', 'Lao People''s Democratic Republic', 'LAO', 418, 856),
(117, 'LV', 'LATVIA', 'Latvia', 'LVA', 428, 371),
(118, 'LB', 'LEBANON', 'Lebanon', 'LBN', 422, 961),
(119, 'LS', 'LESOTHO', 'Lesotho', 'LSO', 426, 266),
(120, 'LR', 'LIBERIA', 'Liberia', 'LBR', 430, 231),
(121, 'LY', 'LIBYAN ARAB JAMAHIRIYA', 'Libyan Arab Jamahiriya', 'LBY', 434, 218),
(122, 'LI', 'LIECHTENSTEIN', 'Liechtenstein', 'LIE', 438, 423),
(123, 'LT', 'LITHUANIA', 'Lithuania', 'LTU', 440, 370),
(124, 'LU', 'LUXEMBOURG', 'Luxembourg', 'LUX', 442, 352),
(125, 'MO', 'MACAO', 'Macao', 'MAC', 446, 853),
(126, 'MK', 'NORTH MACEDONIA', 'North Macedonia', 'MKD', 807, 389),
(127, 'MG', 'MADAGASCAR', 'Madagascar', 'MDG', 450, 261),
(128, 'MW', 'MALAWI', 'Malawi', 'MWI', 454, 265),
(129, 'MY', 'MALAYSIA', 'Malaysia', 'MYS', 458, 60),
(130, 'MV', 'MALDIVES', 'Maldives', 'MDV', 462, 960),
(131, 'ML', 'MALI', 'Mali', 'MLI', 466, 223),
(132, 'MT', 'MALTA', 'Malta', 'MLT', 470, 356),
(133, 'MH', 'MARSHALL ISLANDS', 'Marshall Islands', 'MHL', 584, 692),
(134, 'MQ', 'MARTINIQUE', 'Martinique', 'MTQ', 474, 596),
(135, 'MR', 'MAURITANIA', 'Mauritania', 'MRT', 478, 222),
(136, 'MU', 'MAURITIUS', 'Mauritius', 'MUS', 480, 230),
(137, 'YT', 'MAYOTTE', 'Mayotte', 'MYT', 175, 269),
(138, 'MX', 'MEXICO', 'Mexico', 'MEX', 484, 52),
(139, 'FM', 'MICRONESIA, FEDERATED STATES OF', 'Micronesia, Federated States of', 'FSM', 583, 691),
(140, 'MD', 'MOLDOVA, REPUBLIC OF', 'Moldova, Republic of', 'MDA', 498, 373),
(141, 'MC', 'MONACO', 'Monaco', 'MCO', 492, 377),
(142, 'MN', 'MONGOLIA', 'Mongolia', 'MNG', 496, 976),
(143, 'MS', 'MONTSERRAT', 'Montserrat', 'MSR', 500, 1664),
(144, 'MA', 'MOROCCO', 'Morocco', 'MAR', 504, 212),
(145, 'MZ', 'MOZAMBIQUE', 'Mozambique', 'MOZ', 508, 258),
(146, 'MM', 'MYANMAR', 'Myanmar', 'MMR', 104, 95),
(147, 'NA', 'NAMIBIA', 'Namibia', 'NAM', 516, 264),
(148, 'NR', 'NAURU', 'Nauru', 'NRU', 520, 674),
(149, 'NP', 'NEPAL', 'Nepal', 'NPL', 524, 977),
(150, 'NL', 'NETHERLANDS', 'Netherlands', 'NLD', 528, 31),
(151, 'AN', 'NETHERLANDS ANTILLES', 'Netherlands Antilles', 'ANT', 530, 599),
(152, 'NC', 'NEW CALEDONIA', 'New Caledonia', 'NCL', 540, 687),
(153, 'NZ', 'NEW ZEALAND', 'New Zealand', 'NZL', 554, 64),
(154, 'NI', 'NICARAGUA', 'Nicaragua', 'NIC', 558, 505),
(155, 'NE', 'NIGER', 'Niger', 'NER', 562, 227),
(156, 'NG', 'NIGERIA', 'Nigeria', 'NGA', 566, 234),
(157, 'NU', 'NIUE', 'Niue', 'NIU', 570, 683),
(158, 'NF', 'NORFOLK ISLAND', 'Norfolk Island', 'NFK', 574, 672),
(159, 'MP', 'NORTHERN MARIANA ISLANDS', 'Northern Mariana Islands', 'MNP', 580, 1670),
(160, 'NO', 'NORWAY', 'Norway', 'NOR', 578, 47),
(161, 'OM', 'OMAN', 'Oman', 'OMN', 512, 968),
(162, 'PK', 'PAKISTAN', 'Pakistan', 'PAK', 586, 92),
(163, 'PW', 'PALAU', 'Palau', 'PLW', 585, 680),
(164, 'PS', 'PALESTINIAN TERRITORY, OCCUPIED', 'Palestinian Territory, Occupied', NULL, NULL, 970),
(165, 'PA', 'PANAMA', 'Panama', 'PAN', 591, 507),
(166, 'PG', 'PAPUA NEW GUINEA', 'Papua New Guinea', 'PNG', 598, 675),
(167, 'PY', 'PARAGUAY', 'Paraguay', 'PRY', 600, 595),
(168, 'PE', 'PERU', 'Peru', 'PER', 604, 51),
(169, 'PH', 'PHILIPPINES', 'Philippines', 'PHL', 608, 63),
(170, 'PN', 'PITCAIRN', 'Pitcairn', 'PCN', 612, 0),
(171, 'PL', 'POLAND', 'Poland', 'POL', 616, 48),
(172, 'PT', 'PORTUGAL', 'Portugal', 'PRT', 620, 351),
(173, 'PR', 'PUERTO RICO', 'Puerto Rico', 'PRI', 630, 1787),
(174, 'QA', 'QATAR', 'Qatar', 'QAT', 634, 974),
(175, 'RE', 'REUNION', 'Reunion', 'REU', 638, 262),
(176, 'RO', 'ROMANIA', 'Romania', 'ROU', 642, 40),
(177, 'RU', 'RUSSIAN FEDERATION', 'Russian Federation', 'RUS', 643, 7),
(178, 'RW', 'RWANDA', 'Rwanda', 'RWA', 646, 250),
(179, 'SH', 'SAINT HELENA', 'Saint Helena', 'SHN', 654, 290),
(180, 'KN', 'SAINT KITTS AND NEVIS', 'Saint Kitts and Nevis', 'KNA', 659, 1869),
(181, 'LC', 'SAINT LUCIA', 'Saint Lucia', 'LCA', 662, 1758),
(182, 'PM', 'SAINT PIERRE AND MIQUELON', 'Saint Pierre and Miquelon', 'SPM', 666, 508),
(183, 'VC', 'SAINT VINCENT AND THE GRENADINES', 'Saint Vincent and the Grenadines', 'VCT', 670, 1784),
(184, 'WS', 'SAMOA', 'Samoa', 'WSM', 882, 684),
(185, 'SM', 'SAN MARINO', 'San Marino', 'SMR', 674, 378),
(186, 'ST', 'SAO TOME AND PRINCIPE', 'Sao Tome and Principe', 'STP', 678, 239),
(187, 'SA', 'SAUDI ARABIA', 'Saudi Arabia', 'SAU', 682, 966),
(188, 'SN', 'SENEGAL', 'Senegal', 'SEN', 686, 221),
(189, 'RS', 'SERBIA', 'Serbia', 'SRB', 688, 381),
(190, 'SC', 'SEYCHELLES', 'Seychelles', 'SYC', 690, 248),
(191, 'SL', 'SIERRA LEONE', 'Sierra Leone', 'SLE', 694, 232),
(192, 'SG', 'SINGAPORE', 'Singapore', 'SGP', 702, 65),
(193, 'SK', 'SLOVAKIA', 'Slovakia', 'SVK', 703, 421),
(194, 'SI', 'SLOVENIA', 'Slovenia', 'SVN', 705, 386),
(195, 'SB', 'SOLOMON ISLANDS', 'Solomon Islands', 'SLB', 90, 677),
(196, 'SO', 'SOMALIA', 'Somalia', 'SOM', 706, 252),
(197, 'ZA', 'SOUTH AFRICA', 'South Africa', 'ZAF', 710, 27),
(198, 'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'South Georgia and the South Sandwich Islands', 'SGS', 239, 0),
(199, 'ES', 'SPAIN', 'Spain', 'ESP', 724, 34),
(200, 'LK', 'SRI LANKA', 'Sri Lanka', 'LKA', 144, 94),
(201, 'SD', 'SUDAN', 'Sudan', 'SDN', 736, 249),
(202, 'SR', 'SURINAME', 'Suriname', 'SUR', 740, 597),
(203, 'SJ', 'SVALBARD AND JAN MAYEN', 'Svalbard and Jan Mayen', 'SJM', 744, 47),
(204, 'SZ', 'SWAZILAND', 'Swaziland', 'SWZ', 748, 268),
(205, 'SE', 'SWEDEN', 'Sweden', 'SWE', 752, 46),
(206, 'CH', 'SWITZERLAND', 'Switzerland', 'CHE', 756, 41),
(207, 'SY', 'SYRIAN ARAB REPUBLIC', 'Syrian Arab Republic', 'SYR', 760, 963),
(208, 'TW', 'TAIWAN, PROVINCE OF CHINA', 'Taiwan, Province of China', 'TWN', 158, 886),
(209, 'TJ', 'TAJIKISTAN', 'Tajikistan', 'TJK', 762, 992),
(210, 'TZ', 'TANZANIA, UNITED REPUBLIC OF', 'Tanzania, United Republic of', 'TZA', 834, 255),
(211, 'TH', 'THAILAND', 'Thailand', 'THA', 764, 66),
(212, 'TL', 'TIMOR-LESTE', 'Timor-Leste', 'TLS', 626, 670),
(213, 'TG', 'TOGO', 'Togo', 'TGO', 768, 228),
(214, 'TK', 'TOKELAU', 'Tokelau', 'TKL', 772, 690),
(215, 'TO', 'TONGA', 'Tonga', 'TON', 776, 676),
(216, 'TT', 'TRINIDAD AND TOBAGO', 'Trinidad and Tobago', 'TTO', 780, 1868),
(217, 'TN', 'TUNISIA', 'Tunisia', 'TUN', 788, 216),
(218, 'TR', 'TURKEY', 'Turkey', 'TUR', 792, 90),
(219, 'TM', 'TURKMENISTAN', 'Turkmenistan', 'TKM', 795, 993),
(220, 'TC', 'TURKS AND CAICOS ISLANDS', 'Turks and Caicos Islands', 'TCA', 796, 1649),
(221, 'TV', 'TUVALU', 'Tuvalu', 'TUV', 798, 688),
(222, 'UG', 'UGANDA', 'Uganda', 'UGA', 800, 256),
(223, 'UA', 'UKRAINE', 'Ukraine', 'UKR', 804, 380),
(224, 'AE', 'UNITED ARAB EMIRATES', 'United Arab Emirates', 'ARE', 784, 971),
(225, 'GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826, 44),
(226, 'US', 'UNITED STATES', 'United States', 'USA', 840, 1),
(227, 'UM', 'UNITED STATES MINOR OUTLYING ISLANDS', 'United States Minor Outlying Islands', 'UMI', 581, 1),
(228, 'UY', 'URUGUAY', 'Uruguay', 'URY', 858, 598),
(229, 'UZ', 'UZBEKISTAN', 'Uzbekistan', 'UZB', 860, 998),
(230, 'VU', 'VANUATU', 'Vanuatu', 'VUT', 548, 678),
(231, 'VE', 'VENEZUELA', 'Venezuela', 'VEN', 862, 58),
(232, 'VN', 'VIET NAM', 'Viet Nam', 'VNM', 704, 84),
(233, 'VG', 'VIRGIN ISLANDS, BRITISH', 'Virgin Islands, British', 'VGB', 92, 1284),
(234, 'VI', 'VIRGIN ISLANDS, U.S.', 'Virgin Islands, U.s.', 'VIR', 850, 1340),
(235, 'WF', 'WALLIS AND FUTUNA', 'Wallis and Futuna', 'WLF', 876, 681),
(236, 'EH', 'WESTERN SAHARA', 'Western Sahara', 'ESH', 732, 212),
(237, 'YE', 'YEMEN', 'Yemen', 'YEM', 887, 967),
(238, 'ZM', 'ZAMBIA', 'Zambia', 'ZMB', 894, 260),
(239, 'ZW', 'ZIMBABWE', 'Zimbabwe', 'ZWE', 716, 263),
(240, 'ME', 'MONTENEGRO', 'Montenegro', 'MNE', 499, 382),
(241, 'XK', 'KOSOVO', 'Kosovo', 'XKX', 0, 383),
(242, 'AX', 'ALAND ISLANDS', 'Aland Islands', 'ALA', 248, 358),
(243, 'BQ', 'BONAIRE, SINT EUSTATIUS AND SABA', 'Bonaire, Sint Eustatius and Saba', 'BES', 535, 599),
(244, 'CW', 'CURACAO', 'Curacao', 'CUW', 531, 599),
(245, 'GG', 'GUERNSEY', 'Guernsey', 'GGY', 831, 44),
(246, 'IM', 'ISLE OF MAN', 'Isle of Man', 'IMN', 833, 44),
(247, 'JE', 'JERSEY', 'Jersey', 'JEY', 832, 44),
(248, 'BL', 'SAINT BARTHELEMY', 'Saint Barthelemy', 'BLM', 652, 590),
(249, 'MF', 'SAINT MARTIN', 'Saint Martin', 'MAF', 663, 590),
(250, 'SX', 'SINT MAARTEN', 'Sint Maarten', 'SXM', 534, 1),
(251, 'SS', 'SOUTH SUDAN', 'South Sudan', 'SSD', 728, 211);

INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (1, 'John', 'Doe', 'john.doe@example.com', 'password_hash_1');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (2, 'Jane', 'Doe', 'jane.doe@example.com', 'password_hash_2');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (3, 'James', 'Smith', 'james.smith@example.com', 'password_hash_3');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (4, 'Olivia', 'Johnson', 'olivia.johnson@example.com', 'password_hash_4');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (5, 'Emily', 'Brown', 'emily.brown@example.com', 'password_hash_5');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (1, 'Michael', 'Taylor', 'michael.taylor@example.com', 'password_hash_6');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (2, 'Sophia', 'Miller', 'sophia.miller@example.com', 'password_hash_7');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (3, 'William', 'Wilson', 'william.wilson@example.com', 'password_hash_8');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (4, 'Grace', 'Moore', 'grace.moore@example.com', 'password_hash_9');
INSERT INTO staff_accounts (role_id, first_name, last_name, email, password_hash) VALUES (5, 'Ella', 'Jackson', 'ella.jackson@example.com', 'password_hash_10');



-- INSERT INTO categories (category_name, category_description) VALUES ('Clothing', 'Apparel for men, women, and children');
-- INSERT INTO categories (category_name, category_description) VALUES ('Footwear', 'Shoes, sandals, and boots for all ages');
-- INSERT INTO categories (category_name, category_description) VALUES ('Books', 'Fiction, non-fiction, and educational books');
-- INSERT INTO categories (category_name, category_description) VALUES ('Toys & Games', 'Toys, puzzles, board games, and video games');
-- INSERT INTO categories (category_name, category_description) VALUES ('Sports & Outdoors', 'Sports equipment, camping gear, and outdoor accessories');
-- INSERT INTO categories (category_name, category_description) VALUES ('Beauty & Health', 'Cosmetics, skincare, and health products');
-- INSERT INTO categories (category_name, category_description) VALUES ('Home & Garden', 'Home decor, furniture, and gardening tools');
-- INSERT INTO categories (category_name, category_description) VALUES ('Kitchen & Dining', 'Cookware, tableware, and kitchen appliances');
-- INSERT INTO categories (category_name, category_description) VALUES ('Jewelry & Watches', 'Necklaces, rings, earrings, and watches');
-- INSERT INTO categories (category_name, category_description) VALUES ('Office Supplies', 'Stationery, office furniture, and equipment');
-- INSERT INTO categories (category_name, category_description) VALUES ('Automotive', 'Car parts, accessories, and tools');
-- INSERT INTO categories (category_name, category_description) VALUES ('Pet Supplies', 'Food, toys, and accessories for pets');
-- INSERT INTO categories (category_name, category_description) VALUES ('Movies & Music', 'DVDs, Blu-rays, CDs, and streaming services');
-- INSERT INTO categories (category_name, category_description) VALUES ('Art & Crafts', 'Art supplies, crafting materials, and DIY kits');
INSERT INTO public.categories (parent_id,category_name,category_description,icon,image,placeholder,active,created_at,updated_at,created_by,updated_by) VALUES
(NULL,'Clothing','Apparel for men, women, and children',NULL,NULL,NULL,true,'2023-04-01 09:34:54.408705+05:30','2023-04-01 09:34:54.408705+05:30',NULL,NULL),
(NULL,'Footwear','Shoes, sandals, and boots for all ages',NULL,NULL,NULL,true,'2023-04-01 09:34:54.409422+05:30','2023-04-01 09:34:54.409422+05:30',NULL,NULL),
(NULL,'Books','Fiction, non-fiction, and educational books',NULL,NULL,NULL,true,'2023-04-01 09:34:54.409695+05:30','2023-04-01 09:34:54.409695+05:30',NULL,NULL),
(NULL,'Toys & Games','Toys, puzzles, board games, and video games',NULL,NULL,NULL,true,'2023-04-01 09:34:54.40994+05:30','2023-04-01 09:34:54.40994+05:30',NULL,NULL),
(NULL,'Sports & Outdoors','Sports equipment, camping gear, and outdoor accessories',NULL,NULL,NULL,true,'2023-04-01 09:34:54.410185+05:30','2023-04-01 09:34:54.410185+05:30',NULL,NULL),
(NULL,'Beauty & Health','Cosmetics, skincare, and health products',NULL,NULL,NULL,true,'2023-04-01 09:34:54.410437+05:30','2023-04-01 09:34:54.410437+05:30',NULL,NULL),
(NULL,'Home & Garden','Home decor, furniture, and gardening tools',NULL,NULL,NULL,true,'2023-04-01 09:34:54.410664+05:30','2023-04-01 09:34:54.410664+05:30',NULL,NULL),
(NULL,'Kitchen & Dining','Cookware, tableware, and kitchen appliances',NULL,NULL,NULL,true,'2023-04-01 09:34:54.411008+05:30','2023-04-01 09:34:54.411008+05:30',NULL,NULL),
(NULL,'Jewelry & Watches','Necklaces, rings, earrings, and watches',NULL,NULL,NULL,true,'2023-04-01 09:34:54.411207+05:30','2023-04-01 09:34:54.411207+05:30',NULL,NULL),
(NULL,'Office Supplies','Stationery, office furniture, and equipment',NULL,NULL,NULL,true,'2023-04-01 09:34:54.41144+05:30','2023-04-01 09:34:54.41144+05:30',NULL,NULL);
INSERT INTO public.categories (parent_id,category_name,category_description,icon,image,placeholder,active,created_at,updated_at,created_by,updated_by) VALUES
(NULL,'Automotive','Car parts, accessories, and tools',NULL,NULL,NULL,true,'2023-04-01 09:34:54.411611+05:30','2023-04-01 09:34:54.411611+05:30',NULL,NULL),
(NULL,'Pet Supplies','Food, toys, and accessories for pets',NULL,NULL,NULL,true,'2023-04-01 09:34:54.411793+05:30','2023-04-01 09:34:54.411793+05:30',NULL,NULL),
(NULL,'Movies & Music','DVDs, Blu-rays, CDs, and streaming services',NULL,NULL,NULL,true,'2023-04-01 09:34:54.411972+05:30','2023-04-01 09:34:54.411972+05:30',NULL,NULL),
(NULL,'Art & Crafts','Art supplies, crafting materials, and DIY kits',NULL,NULL,NULL,true,'2023-04-01 09:34:54.412145+05:30','2023-04-01 09:34:54.412145+05:30',NULL,NULL),
(NULL,'Electronics','Electronic devices and gadgets',NULL,NULL,NULL,true,'2023-04-01 09:35:22.500841+05:30','2023-04-01 09:35:22.500841+05:30',NULL,NULL),
(15,'Mobiles','All mobile phones',NULL,NULL,NULL,true,'2023-04-01 09:36:36.828167+05:30','2023-04-01 09:36:36.828167+05:30',NULL,NULL),
(16,'Smartphones','All smartphones',NULL,NULL,NULL,true,'2023-04-01 09:36:36.828167+05:30','2023-04-01 09:36:36.828167+05:30',NULL,NULL),
(16,'Feature phones','All feature phones',NULL,NULL,NULL,true,'2023-04-01 09:36:36.828167+05:30','2023-04-01 09:36:36.828167+05:30',NULL,NULL),
(15,'Laptops','All laptops',NULL,NULL,NULL,true,'2023-04-01 09:37:09.235664+05:30','2023-04-01 09:37:09.235664+05:30',NULL,NULL),
(19,'Windows laptops','All Windows-based laptops',NULL,NULL,NULL,true,'2023-04-01 09:38:08.365351+05:30','2023-04-01 09:38:08.365351+05:30',NULL,NULL);
INSERT INTO public.categories (parent_id,category_name,category_description,icon,image,placeholder,active,created_at,updated_at,created_by,updated_by) VALUES
(19,'Mac laptops','All Mac-based laptops',NULL,NULL,NULL,true,'2023-04-01 09:38:28.08063+05:30','2023-04-01 09:38:28.08063+05:30',NULL,NULL),
(19,'Chromebook laptops','All Chromebook-based laptops',NULL,NULL,NULL,true,'2023-04-01 09:38:28.08063+05:30','2023-04-01 09:38:28.08063+05:30',NULL,NULL),
(NULL,'Mobiles_1','Phoes devices and gadgets','https://example.com/icon/electronics.png','https://example.com/image/electronics.jpg','https://example.com/placeholder/electronics.jpg',true,'2023-04-01 10:02:29.812+05:30','2023-04-01 10:02:29.812+05:30',NULL,NULL);


INSERT INTO products (slug, product_name, sku, sale_price, compare_price, buying_price, quantity, short_description, product_description, product_type, published, disable_out_of_stock, note, created_at, updated_at, created_by, updated_by)
VALUES
    ('product-1', 'Product 1', 'SKU-1', 99.99, 119.99, 79.99, 50, 'Short description of product 1', 'Long description of product 1', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-2', 'Product 2', 'SKU-2', 149.99, 169.99, 129.99, 25, 'Short description of product 2', 'Long description of product 2', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-3', 'Product 3', 'SKU-3', 79.99, 0, null, 100, 'Short description of product 3', 'Long description of product 3', 'simple', true, false, null, NOW(), NOW(), 1, 1),
    ('product-4', 'Product 4', 'SKU-4', 299.99, 349.99, 249.99, 10, 'Short description of product 4', 'Long description of product 4', 'variable', true, true, null, NOW(), NOW(), 1, 1),
    ('product-5', 'Product 5', 'SKU-5', 399.99, 0, null, 5, 'Short description of product 5', 'Long description of product 5', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-6', 'Product 6', 'SKU-6', 59.99, 0, null, 200, 'Short description of product 6', 'Long description of product 6', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-7', 'Product 7', 'SKU-7', 199.99, 0, null, 15, 'Short description of product 7', 'Long description of product 7', 'simple', true, false, null, NOW(), NOW(), 1, 1),
    ('product-8', 'Product 8', 'SKU-8', 1499.99, 1599.99, 1199.99, 3, 'Short description of product 8', 'Long description of product 8', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-9', 'Product 9', 'SKU-9', 29.99, 0, null, 500, 'Short description of product 9', 'Long description of product 9', 'simple', true, true, null, NOW(), NOW(), 1, 1),
    ('product-10', 'Product 10', 'SKU-10', 499.99, 599.99, 399.99, 5, 'Short description of product 10', 'Long description of product 10', 'variable', true, true, null, NOW(), NOW(), 1, 1),
    ('product-21', 'Product 21', 'SKU-21', 100.00, 0.00, 80.00, 50, 'Short description for product 21', 'Long description for product 21', 'simple', true, true, 'Note for product 21', NOW(), NOW(), 1, 1),
    ('product-22', 'Product 22', 'SKU-22', 99.99, 129.99, 75.00, 100, 'Short description for product 22', 'Long description for product 22', 'variable', true, false, 'Note for product 22', NOW(), NOW(), 1, 1),
    ('product-23', 'Product 23', 'SKU-23', 249.99, 0.00, 200.00, 20, 'Short description for product 23', 'Long description for product 23', 'simple', true, true, 'Note for product 23', NOW(), NOW(), 1, 1),
    ('product-24', 'Product 24', 'SKU-24', 19.99, 0.00, 10.00, 200, 'Short description for product 24', 'Long description for product 24', 'simple', true, true, 'Note for product 24', NOW(), NOW(), 1, 1),
    ('product-25', 'Product 25', 'SKU-25', 129.99, 0.00, 100.00, 30, 'Short description for product 25', 'Long description for product 25', 'simple', true, true, 'Note for product 25', NOW(), NOW(), 1, 1),
    ('product-26', 'Product 26', 'SKU-26', 399.99, 0.00, 350.00, 10, 'Short description for product 26', 'Long description for product 26', 'simple', true, true, 'Note for product 26', NOW(), NOW(), 1, 1),
    ('product-27', 'Product 27', 'SKU-27', 399.99, 499.99, 350.00, 50, 'Short description for product 27', 'Long description for product 27', 'variable', true, false, 'Note for product 27', NOW(), NOW(), 1, 1),
    ('product-28', 'Product 28', 'SKU-28', 299.99, 399.99, 250.00, 50, 'Short description for product 28', 'Long description for product 28', 'variable', true, false, 'Note for product 28', NOW(), NOW(), 1, 1),
    ('product-29', 'Product 29', 'SKU-29', 149.99, 0.00, 100.00, 40, 'Short description for product 29', 'Long description for product 29', 'simple', true, true, 'Note for product 29', NOW(), NOW(), 1, 1);

INSERT INTO public.product_categories (product_id, category_id)
VALUES
    (1, 1),
    (1, 3),
    (2, 2),
    (2, 3),
    (3, 3),
    (4, 2),
    (4, 4),
    (4, 5),
    (5, 1),
    (5, 4),
    (6, 1),
    (6, 2),
    (7, 2),
    (7, 4),
    (7, 5),
    (8, 1),
    (8, 2),
    (9, 3),
    (10, 4),
    (10, 5),
    (11, 1),
    (12, 3),
    (13, 1),
    (14, 5),
    (15, 3),
    (15, 5),
    (16, 2),
    (16, 5),
    (17, 1),
    (17, 4),
    (18, 1),
    (18, 5),
    (19, 3),
    (19, 4);




INSERT INTO product_shipping_info (product_id, weight, weight_unit, volume, volume_unit, dimension_width, dimension_height, dimension_depth, dimension_unit)
VALUES
    (1, 0.5, 'kg', 1, 'l', 20, 30, 40, 'cm'),
    (2, 0.75, 'kg', 2, 'l', 25, 35, 45, 'cm'),
    (3, 0.2, 'kg', 0.5, 'l', 15, 25, 35, 'cm'),
    (4, 1, 'kg', 3, 'l', 30, 40, 50, 'cm'),
    (5, 0.5, 'kg', 1, 'l', 20, 30, 40, 'cm'),
    (6, 1.5, 'kg', 5, 'l', 40, 50, 60, 'cm'),
    (7, 0.75, 'kg', 2, 'l', 25, 35, 45, 'cm'),
    (8, 0.2, 'kg', 0.5, 'l', 15, 25, 35, 'cm'),
    (9, 1, 'kg', 3, 'l', 30, 40, 50, 'cm'),
    (10, 0.5, 'kg', 1, 'l', 20, 30, 40, 'cm'),
    (11, 0.75, 'kg', 2, 'l', 25, 35, 45, 'cm'),
    (12, 0.2, 'kg', 0.5, 'l', 15, 25, 35, 'cm'),
    (13, 1, 'kg', 3, 'l', 30, 40, 50, 'cm'),
    (14, 0.5, 'kg', 1, 'l', 20, 30, 40, 'cm'),
    (15, 1.5, 'kg', 5, 'l', 40, 50, 60, 'cm'),
    (16, 0.75, 'kg', 2, 'l', 25, 35, 45, 'cm'),
    (17, 0.2, 'kg', 0.5, 'l', 15, 25, 35, 'cm'),
    (18, 1, 'kg', 3, 'l', 30, 40, 50, 'cm'),
    (19, 0.5, 'kg', 1, 'l', 20, 30, 40, 'cm');



INSERT INTO attributes (attribute_name, created_by, updated_by) VALUES
('Color', 1, 1), ('Size', 1, 1), ('Material', 1, 1), ('Weight', 1, 1),
('Brand', 1, 1), ('Model', 1, 1), ('Style', 1, 1), ('Shape', 1, 1),
('Country of Origin', 1, 1), ('Manufacturer', 1, 1), ('Warranty', 1, 1),
('Dimensions', 1, 1), ('Capacity', 1, 1), ('Voltage', 1, 1), ('Power', 1, 1),
('Speed', 1, 1), ('RAM', 1, 1), ('Storage', 1, 1), ('Display', 1, 1);


INSERT INTO attribute_values (attribute_id, attribute_value)
VALUES
    (1, 'Red'),
    (1, 'Blue'),
    (1, 'Green'),
    (2, 'Small'),
    (2, 'Medium'),
    (2, 'Large'),
    (3, 'Cotton'),
    (3, 'Polyester'),
    (3, 'Leather'),
    (4, '100 g'),
    (4, '200 g'),
    (4, '300 g'),
    (5, 'Nike'),
    (5, 'Adidas'),
    (5, 'Puma'),
    (6, 'Model A'),
    (6, 'Model B'),
    (6, 'Model C'),
    (7, 'Casual'),
    (7, 'Formal'),
    (7, 'Sports'),
    (8, 'Rectangle'),
    (8, 'Square'),
    (8, 'Circle'),
    (9, 'China'),
    (9, 'USA'),
    (9, 'Germany'),
    (10, 'Manufacturer X'),
    (10, 'Manufacturer Y'),
    (10, 'Manufacturer Z'),
    (11, '1 year'),
    (11, '2 years'),
    (11, '3 years'),
    (12, '10 x 20 x 30 cm'),
    (12, '20 x 30 x 40 cm'),
    (12, '30 x 40 x 50 cm');






INSERT INTO customers (first_name, last_name, email, password_hash, active, registered_at, updated_at)
VALUES
    ('John', 'Doe', 'johndoe@gmail.com', 'hash1', true, NOW(), NOW()),
    ('Jane', 'Doe', 'janedoe@yahoo.com', 'hash2', true, NOW(), NOW()),
    ('Bob', 'Smith', 'bobsmith@hotmail.com', 'hash3', true, NOW(), NOW()),
    ('Alice', 'Jones', 'alicejones@gmail.com', 'hash4', true, NOW(), NOW()),
    ('Tom', 'Wilson', 'tomwilson@gmail.com', 'hash5', true, NOW(), NOW()),
    ('Emily', 'Brown', 'emilybrown@yahoo.com', 'hash6', true, NOW(), NOW()),
    ('David', 'Lee', 'davidlee@gmail.com', 'hash7', true, NOW(), NOW()),
    ('Megan', 'Wang', 'meganwang@yahoo.com', 'hash8', true, NOW(), NOW()),
    ('Jack', 'Johnson', 'jackjohnson@hotmail.com', 'hash9', true, NOW(), NOW()),
    ('Sarah', 'Kim', 'sarahkim@gmail.com', 'hash10', true, NOW(), NOW());



INSERT INTO products (slug, product_name, sale_price, compare_price, quantity, short_description, product_description, product_type, published)
VALUES ('mens-graphic-t-shirt', 'Men''s Graphic T-shirt', 20.00, 25.00, 100, 'Stylish Men''s Graphic T-shirt', 'High-quality Men''s Graphic T-shirt made of comfortable materials. Perfect for casual wear.', 'variable', TRUE);

INSERT INTO products (slug, product_name, sale_price, compare_price, quantity, short_description, product_description, product_type, published)
VALUES ('womens-plain-t-shirt', 'Women''s Plain T-shirt', 15.00, 20.00, 100, 'Comfortable Women''s Plain T-shirt', 'Classic Women''s Plain T-shirt made of soft materials. A wardrobe essential for everyday wear.', 'variable', TRUE);



INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (2, 'S');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (2, 'M');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (2, 'L');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (2, 'XL');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (1, 'Red');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (1, 'Blue');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (1, 'Green');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (1, 'Black');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (5, 'Cotton');
INSERT INTO attribute_values (attribute_id, attribute_value) VALUES (5, 'Polyester');


INSERT INTO product_attributes (product_id, attribute_id) VALUES (20, 1);
INSERT INTO product_attributes (product_id, attribute_id) VALUES (20, 2);
INSERT INTO product_attributes (product_id, attribute_id) VALUES (20, 5);
INSERT INTO product_attributes (product_id, attribute_id) VALUES (21, 1);
INSERT INTO product_attributes (product_id, attribute_id) VALUES (21, 2);
INSERT INTO product_attributes (product_id, attribute_id) VALUES (21, 5);


-- Size
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (1, 48); -- S
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (1, 49); -- M
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (1, 50); -- L
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (1, 51); -- XL

-- Color
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (2, 52); -- Red
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (2, 53); -- Blue
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (2, 54); -- Green
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (2, 55); -- Black

-- Material
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (3, 56); -- Cotton
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (3, 57); -- Polyester


-- Size
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (4, 48); -- S
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (4, 49); -- M
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (4, 50); -- L
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (4, 51); -- XL

-- Color
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (5, 52); -- Red
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (5, 53); -- Blue
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (5, 54); -- Green
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (5, 55); -- Black

-- Material
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (6, 56); -- Cotton
INSERT INTO product_attribute_values (product_attribute_id, attribute_value_id) VALUES (6, 57); -- Polyester




-- variant_options
INSERT INTO variant_options (title, product_id, sale_price) VALUES ('Men''s Graphic T-shirt - S / Red / Cotton', 20, 20.00);
INSERT INTO variant_options (title, product_id, sale_price) VALUES ('Men''s Graphic T-shirt - S / Red / Polyester', 20, 20.00);

-- variants
INSERT INTO variants (variant_option, product_id, variant_option_id) VALUES ('Size: S, Color: Red, Material: Cotton', 20, 1);
INSERT INTO variants (variant_option, product_id, variant_option_id) VALUES ('Size: S, Color: Red, Material: Polyester', 20, 2);


-- variant_options
INSERT INTO variant_options (title, product_id, sale_price) VALUES ('Women''s Plain T-shirt - S / Red / Cotton', 21, 15.00);
INSERT INTO variant_options (title, product_id, sale_price) VALUES ('Women''s Plain T-shirt - S / Red / Polyester', 21, 15.00);

-- variants
INSERT INTO variants (variant_option, product_id, variant_option_id) VALUES ('Size: S, Color: Red, Material: Cotton', 21, 3);
INSERT INTO variants (variant_option, product_id, variant_option_id) VALUES ('Size: S, Color: Red, Material: Polyester', 21, 4);


-- Variant 1: Size: S, Color: Red, Material: Cotton
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (1, 1); -- Size: S
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (1, 2); -- Color: Red
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (1, 3); -- Material: Cotton

-- Variant 2: Size: S, Color: Red, Material: Polyester
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (2, 1); -- Size: S
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (2, 2); -- Color: Red
INSERT INTO variant_values (variant_id, product_attribute_value_id) VALUES (2, 4); -- Material: Polyester

