-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`restaurantCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`restaurantCategories` (
  `restaurant_category_id` INT NOT NULL AUTO_INCREMENT,
  `restaurant_category_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`restaurant_category_id`));


-- -----------------------------------------------------
-- Table `mydb`.`restaurants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`restaurants` (
  `restaurant_id` INT NOT NULL AUTO_INCREMENT,
  `restaurant_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL,
  `city` VARCHAR(45) NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `open_time` TIME NOT NULL,
  `close_time` TIME NOT NULL,
  `holiday_schedule` VARCHAR(30) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `restaurant_category_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  INDEX `fk_resturant_restaurantCategories1_idx` (`restaurant_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_resturant_restaurantCategories1`
    FOREIGN KEY (`restaurant_category_id`)
    REFERENCES `mydb`.`restaurantCategories` (`restaurant_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`menuCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`menuCategories` (
  `menu_category_id` INT NOT NULL,
  `category_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`menu_category_id`));


-- -----------------------------------------------------
-- Table `mydb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`menu` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `menu_name` VARCHAR(60) NOT NULL,
  `menu_price` DECIMAL(10,2) NOT NULL,
  `restaurant_Id` INT NOT NULL,
  `menu_category_id` INT NOT NULL,
  PRIMARY KEY (`menu_id`),
  INDEX `fk_menu_resturant_idx` (`restaurant_Id` ASC) VISIBLE,
  INDEX `fk_menu_menuCategories1_idx` (`menu_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_menu_resturant`
    FOREIGN KEY (`restaurant_Id`)
    REFERENCES `mydb`.`restaurants` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_menu_menuCategories1`
    FOREIGN KEY (`menu_category_id`)
    REFERENCES `mydb`.`menuCategories` (`menu_category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(60) NOT NULL,
  `last_name` VARCHAR(60) NOT NULL,
  `user_name` VARCHAR(30) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `payment_method` VARCHAR(30) NOT NULL,
  `payment_date` DATE NOT NULL,
  `tip_amount` DECIMAL(10,2) ZEROFILL NULL,
  `status` ENUM('waiting', 'success', 'canceled') NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payments_customers1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_payments_customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`riders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`riders` (
  `rider_id` INT NOT NULL AUTO_INCREMENT,
  `rider_fname` VARCHAR(60) NOT NULL,
  `rider_lname` VARCHAR(60) NOT NULL,
  `rider_phone` VARCHAR(15) NOT NULL,
  `rider_email` VARCHAR(255) NOT NULL,
  `driver_license` VARCHAR(25) NOT NULL,
  `plate_number` VARCHAR(10) NOT NULL,
  `rider_address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`rider_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATE NOT NULL,
  `status` ENUM('waiting', 'confirmed', 'preparing', 'ready', 'out of delivery', 'delivered', 'canceled', 'failed') NOT NULL,
  `total_amount` DECIMAL NOT NULL,
  `shipping_cost` DECIMAL(10,2) NOT NULL,
  `customer_id` INT NOT NULL,
  `payment_id` INT NULL,
  `rider_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_customers1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_orders_payments1_idx` (`payment_id` ASC) VISIBLE,
  INDEX `fk_orders_riders1_idx` (`rider_id` ASC) VISIBLE,
  INDEX `fk_orders_restaurants1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_payments1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `mydb`.`payments` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_riders1`
    FOREIGN KEY (`rider_id`)
    REFERENCES `mydb`.`riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_restaurants1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `mydb`.`restaurants` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`restaurantReview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`restaurantReview` (
  `res_review_Id` INT NOT NULL AUTO_INCREMENT,
  `rating` ENUM('excellent', 'good', 'average', 'fair', 'poor') NOT NULL,
  `comment` VARCHAR(255) NULL,
  `order_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  PRIMARY KEY (`res_review_Id`),
  INDEX `fk_resturantReview_resturant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_resturantReview_orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_resturantReview_resturant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `mydb`.`restaurants` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`membership` (
  `membership_id` INT NOT NULL AUTO_INCREMENT,
  `member_type` ENUM('Classic', 'Silver', 'Gold', 'Platinum') NOT NULL,
  `point` DECIMAL(10,2) NOT NULL,
  `expiry_date` DATE NOT NULL,
  `discount` DECIMAL NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`membership_id`),
  INDEX `fk_membership_customers1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_membership_customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orderDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`orderDetails` (
  `order_detail_Id` INT NOT NULL AUTO_INCREMENT,
  `menu_id` INT NOT NULL,
  `menu_name` VARCHAR(60) NOT NULL,
  `quantity_ordered` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`order_detail_Id`),
  INDEX `fk_orderDetails_menu1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_orderDetails_orders1_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_orderDetails_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `mydb`.`menu` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orderDetails_orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`riderReview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`riderReview` (
  `rider_review_id` INT NOT NULL AUTO_INCREMENT,
  `rating` ENUM('excellent', 'good', 'average', 'fair', 'poor') NOT NULL,
  `comment` VARCHAR(255) NULL,
  `order_id` INT NOT NULL,
  `rider_id` INT NOT NULL,
  PRIMARY KEY (`rider_review_id`),
  INDEX `fk_riderReview_orders1_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_riderReview_riders1_idx` (`rider_id` ASC) VISIBLE,
  CONSTRAINT `fk_riderReview_orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `mydb`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_riderReview_riders1`
    FOREIGN KEY (`rider_id`)
    REFERENCES `mydb`.`riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`favoriteRestaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`favoriteRestaurant` (
  `restaurant_Id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_Id`, `customer_id`),
  INDEX `fk_resturant_has_customers_customers1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_resturant_has_customers_resturant1_idx` (`restaurant_Id` ASC) VISIBLE,
  CONSTRAINT `fk_resturant_has_customers_resturant1`
    FOREIGN KEY (`restaurant_Id`)
    REFERENCES `mydb`.`restaurants` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_resturant_has_customers_customers1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `mydb`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`riderIncomes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`riderIncomes` (
  `income_id` INT NOT NULL AUTO_INCREMENT,
  `income_date` DATE NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `rider_id` INT NOT NULL,
  PRIMARY KEY (`income_id`),
  INDEX `fk_riderIncomes_riders1_idx` (`rider_id` ASC) VISIBLE,
  CONSTRAINT `fk_riderIncomes_riders1`
    FOREIGN KEY (`rider_id`)
    REFERENCES `mydb`.`riders` (`rider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
