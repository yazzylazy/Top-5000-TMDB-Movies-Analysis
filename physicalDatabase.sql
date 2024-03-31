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
-- Table `mydb`.`Person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Person` (
  `person_id` VARCHAR(45) NOT NULL,
  `name` LONGTEXT NULL,
  `gender` VARCHAR(45) NULL,
  `role` VARCHAR(45) NULL,
  PRIMARY KEY (`person_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ReleaseDate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ReleaseDate` (
  `date_id` INT NOT NULL,
  `day` INT NULL,
  `month` INT NULL,
  `year` INT NULL,
  'quarter' MEDIUMTEXT NULL,
  PRIMARY KEY (`date_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionStudio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionStudio` (
  `productionStudio_id` INT NOT NULL,
  `companyName` LONGTEXT NULL,
  PRIMARY KEY (`productionStudio_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionCountry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionCountry` (
  `productionCountry_id` INT NOT NULL,
  `countryName` LONGTEXT NULL,
  'continentName' LONGTEXT NULL,
  PRIMARY KEY (`productionCountry_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Movie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Movie` (
  `movie_id` INT NOT NULL,
  `title` LONGTEXT NULL,
  `genre` LONGTEXT NULL,
  `original_language` LONGTEXT NULL,
  `spoken_language` LONGTEXT NULL,
  `runtime` INT NULL,
  PRIMARY KEY (`movie_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionStudio-Movie-bridgeTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionStudio-Movie-bridgeTable` (
  `productionStudio_id` INT NULL,
  `movie_id` INT NULL,
  INDEX `fk_productionStudio_id_idx` (`productionStudio_id` ASC) VISIBLE,
  INDEX `fk_productionStudio_movie_id_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_productionStudio_movie_id`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mydb`.`Movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_productionStudio_id`
    FOREIGN KEY (`productionStudio_id`)
    REFERENCES `mydb`.`ProductionStudio` (`productionStudio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionCountry-Movie-bridgeTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionCountry-Movie-bridgeTable` (
  `movie_id` INT NULL,
  `productionCountry_id` INT NULL,
  INDEX `fk_productionCountry_id_idx` (`productionCountry_id` ASC) VISIBLE,
  INDEX `fk_productionCountry_movie_id_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `fk_productionCountry_movie_id`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mydb`.`Movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_productionCountry_id`
    FOREIGN KEY (`productionCountry_id`)
    REFERENCES `mydb`.`ProductionCountry` (`productionCountry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MovieFactTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MovieFactTable` (
  `movie_id` INT NULL,
  `date_id` INT NULL,
  `productionStudio_id` INT NULL,
  `productionCountry_id` INT NULL,
  `budget` INT NULL,
  `voteAverage` FLOAT NULL,
  `voteCount` INT NULL,
  `popularity` INT NULL,
  INDEX `movie_id_idx` (`movie_id` ASC) VISIBLE,
  INDEX `date_id_idx` (`date_id` ASC) VISIBLE,
  INDEX `productionStudio_id_idx` (`productionStudio_id` ASC) VISIBLE,
  INDEX `productionCountry_id_idx` (`productionCountry_id` ASC) VISIBLE,
  CONSTRAINT `movie_id`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mydb`.`Movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `date_id`
    FOREIGN KEY (`date_id`)
    REFERENCES `mydb`.`ReleaseDate` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `productionStudio_id`
    FOREIGN KEY (`productionStudio_id`)
    REFERENCES `mydb`.`ProductionStudio-Movie-bridgeTable` (`productionStudio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `productionCountry_id`
    FOREIGN KEY (`productionCountry_id`)
    REFERENCES `mydb`.`ProductionCountry-Movie-bridgeTable` (`productionCountry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Crew-Movie-bridgeTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Crew-Movie-bridgeTable` (
  `movie_id` INT NULL,
  `crew_id` VARCHAR(45) NULL,
  INDEX `movie_id_idx` (`movie_id` ASC) VISIBLE,
  INDEX `crew_id_idx` (`crew_id` ASC) VISIBLE,
  CONSTRAINT `crew_movie_id_fk`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mydb`.`Movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `crew_id_fk`
    FOREIGN KEY (`crew_id`)
    REFERENCES `mydb`.`Person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Actor-Movie-bridgeTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Actor-Movie-bridgeTable` (
  `movie_id` INT NULL,
  `actor_id` VARCHAR(45) NULL,
  INDEX `movie_id_idx` (`movie_id` ASC) VISIBLE,
  INDEX `actor_id_idx` (`actor_id` ASC) VISIBLE,
  CONSTRAINT `actor_movie_id_fk`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mydb`.`Movie` (`movie_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `actor_id_fk`
    FOREIGN KEY (`actor_id`)
    REFERENCES `mydb`.`Person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
