-- MySQL Script generated by MySQL Workbench
-- 06/01/16 14:12:49
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema bones
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bones
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bones` DEFAULT CHARACTER SET utf8 ;
USE `bones` ;

-- -----------------------------------------------------
-- Table `bones`.`projects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`projects` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(200) NULL,
  `created_at` DATETIME NOT NULL,
  `update_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(20) NOT NULL,
  `lastname` VARCHAR(20) NOT NULL,
  `mail` VARCHAR(45) NOT NULL,
  `role_id` INT NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `remember_token` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_role1_idx` (`role_id` ASC),
  CONSTRAINT `fk_users_role1`
    FOREIGN KEY (`role_id`)
    REFERENCES `bones`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`tasks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `duration` VARCHAR(45) NOT NULL,
  `date_jalon` DATE NULL,
  `statut` VARCHAR(15) NOT NULL,
  `priority` INT NOT NULL,
  `project_id` INT NOT NULL,
  `parent_id` INT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tasks_projects1_idx` (`project_id` ASC),
  INDEX `fk_tasks_tasks1_idx` (`parent_id` ASC),
  CONSTRAINT `fk_tasks_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `bones`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tasks_tasks1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `bones`.`tasks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`files` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(200) NULL,
  `url` VARCHAR(45) NOT NULL,
  `project_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_files_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_files_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `bones`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`users_tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`users_tasks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `task_id` INT NOT NULL,
  INDEX `fk_users_has_tasks_tasks1_idx` (`task_id` ASC),
  INDEX `fk_users_has_tasks_users1_idx` (`user_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_has_tasks_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_tasks_tasks1`
    FOREIGN KEY (`task_id`)
    REFERENCES `bones`.`tasks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`durations_tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`durations_tasks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `ended_at` DATETIME NULL,
  `user_task_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_durations_tasks_users_tasks1_idx` (`user_task_id` ASC),
  CONSTRAINT `fk_durations_tasks_users_tasks1`
    FOREIGN KEY (`user_task_id`)
    REFERENCES `bones`.`users_tasks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`invitations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`invitations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `token` VARCHAR(45) NOT NULL,
  `statut` VARCHAR(45) NULL,
  `guest_id` INT NULL,
  `host_id` INT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `project_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_invitations_users1_idx` (`guest_id` ASC),
  INDEX `fk_invitations_users2_idx` (`host_id` ASC),
  INDEX `fk_invitations_projects1_idx` (`project_id` ASC),
  CONSTRAINT `fk_invitations_users1`
    FOREIGN KEY (`guest_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invitations_users2`
    FOREIGN KEY (`host_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invitations_projects1`
    FOREIGN KEY (`project_id`)
    REFERENCES `bones`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`projects_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`projects_users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `project_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  INDEX `fk_projects_has_users_users1_idx` (`user_id` ASC),
  INDEX `fk_projects_has_users_projects_idx` (`project_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_projects_has_users_projects`
    FOREIGN KEY (`project_id`)
    REFERENCES `bones`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_has_users_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comment` TEXT NOT NULL,
  `user_id` INT NOT NULL,
  `task_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comments_users1_idx` (`user_id` ASC),
  INDEX `fk_comments_tasks1_idx` (`task_id` ASC),
  CONSTRAINT `fk_comments_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_tasks1`
    FOREIGN KEY (`task_id`)
    REFERENCES `bones`.`tasks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bones`.`events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bones`.`events` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  `users_id` INT NOT NULL,
  `projects_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_events_users1_idx` (`users_id` ASC),
  INDEX `fk_events_projects1_idx` (`projects_id` ASC),
  CONSTRAINT `fk_events_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `bones`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_events_projects1`
    FOREIGN KEY (`projects_id`)
    REFERENCES `bones`.`projects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `bones`.`projects`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`projects` (`id`, `name`, `description`, `created_at`, `update_at`) VALUES (1, 'Web Framework', 'Projet semestriel de framework 2016', '2016-03-11 00:00:00', '2016-03-11 00:00:00');
INSERT INTO `bones`.`projects` (`id`, `name`, `description`, `created_at`, `update_at`) VALUES (2, 'Graphisme 2', 'Projet semestriel graphisme s2', '2016-02-01 00:00:00', '2016-02-01 00:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bones`.`roles`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`roles` (`id`, `name`) VALUES (1, 'Eleve');
INSERT INTO `bones`.`roles` (`id`, `name`) VALUES (2, 'Prof');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bones`.`users`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`users` (`id`, `firstname`, `lastname`, `mail`, `role_id`, `password`, `remember_token`) VALUES (1, 'Mick', 'Lacombe', 'mick@mick.com', 1, '$2y$10$TY1RuSfyCxs08Y5YYWNCbedFsGWFE5vm5raiJThrR1Fi7hrn2Kd9u', 'SHMTYA0gBULef7qfujVqa13vtAmUGkXzLPemZBIE4j1jXuQVQCdwxXwPLbeY');
INSERT INTO `bones`.`users` (`id`, `firstname`, `lastname`, `mail`, `role_id`, `password`, `remember_token`) VALUES (2, 'Christouf', 'kalmouf', DEFAULT, 1, '$2y$10$TY1RuSfyCxs08Y5YYWNCbedFsGWFE5vm5raiJThrR1Fi7hrn2Kd9u', 'SHMTYA0gBULef7qfujVqa13vtAmUGkXzLPemZBIE4j1jXuQVQCdwxXwPLbeY');
INSERT INTO `bones`.`users` (`id`, `firstname`, `lastname`, `mail`, `role_id`, `password`, `remember_token`) VALUES (3, 'test', 'test', 'test', 1, '$2y$10$TY1RuSfyCxs08Y5YYWNCbedFsGWFE5vm5raiJThrR1Fi7hrn2Kd9u', 'SHMTYA0gBULef7qfujVqa13vtAmUGkXzLPemZBIE4j1jXuQVQCdwxXwPLbeY');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bones`.`tasks`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (1, 'Analyse', '', NULL, 'en cours', 1, 1, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (2, 'Conception', '', NULL, 'en cours', 1, 1, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (3, 'Rendu', '', NULL, DEFAULT, 1, 1, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (4, 'Analyse marketing', '', NULL, 'en cours', 1, 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (5, 'Analyse 1 concurent', '', NULL, 'en cours', 1, 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (6, 'Analyse 2ème concurent', '', NULL, DEFAULT, 1, 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (7, 'Conception maquettes', '', NULL, DEFAULT, 2, 1, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (8, 'Conception maquette accueil', '', NULL, DEFAULT, 2, 1, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (9, 'Conception maquette articles', '', NULL, DEFAULT, 2, 1, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (10, 'Conception logo', '', NULL, DEFAULT, 3, 1, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (11, 'Conception Controllers/Models', '', NULL, DEFAULT, 1, 1, 3, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (12, 'Conception Routes', '', NULL, DEFAULT, 1, 1, 3, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (13, 'Conception view accueil', '', NULL, DEFAULT, 1, 1, 3, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (14, 'Conception view articles', '', NULL, DEFAULT, 1, 1, 3, '0000-00-00 00:00:00', '0000-00-00 00:00:00');
INSERT INTO `bones`.`tasks` (`id`, `name`, `duration`, `date_jalon`, `statut`, `priority`, `project_id`, `parent_id`, `created_at`, `updated_at`) VALUES (15, 'Tests divers utilisation', '', NULL, DEFAULT, 3, 1, NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `bones`.`users_tasks`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (1, 1, 1);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (2, 2, 2);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (3, 1, 3);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (4, 1, 4);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (5, 2, 5);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (6, 1, 6);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (7, 2, 7);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (8, 1, 8);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (9, 2, 9);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (10, 2, 10);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (11, 2, 12);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (12, 1, 11);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (13, 2, 12);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (14, 1, 13);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (15, 2, 14);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (16, 1, 15);
INSERT INTO `bones`.`users_tasks` (`id`, `user_id`, `task_id`) VALUES (17, 2, 15);

COMMIT;


-- -----------------------------------------------------
-- Data for table `bones`.`projects_users`
-- -----------------------------------------------------
START TRANSACTION;
USE `bones`;
INSERT INTO `bones`.`projects_users` (`id`, `project_id`, `user_id`, `created_at`, `updated_at`) VALUES (1, 1, 1, '2016-03-11 00:00:00', '2016-03-11 00:00:00');
INSERT INTO `bones`.`projects_users` (`id`, `project_id`, `user_id`, `created_at`, `updated_at`) VALUES (2, 1, 2, '2016-03-11 00:00:00', '2016-03-11 00:00:00');
INSERT INTO `bones`.`projects_users` (`id`, `project_id`, `user_id`, `created_at`, `updated_at`) VALUES (3, 2, 3, '2016-02-01 00:00:00', '2016-02-01 00:00:00');

COMMIT;

