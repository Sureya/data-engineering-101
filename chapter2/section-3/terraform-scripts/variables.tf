variable "region" {
  type = "string"
  description = "AWS region in which the resources needs to be deployed"
  default = "eu-west-2"
}

variable "db_user" {
  type = "string"
  description = "DB username"
  default = "developer"
}

variable "postgres_version" {
  type = "string"
  description = "Postgres family version name"
  default = "postgres9.6"
}

variable "db_instance_type" {
  type = "string"
  description = "EC2 instamce type"
  default = "db.t2.micro"
}

variable "db_name" {
  type = "string"
  description = "name of the Database"
  default = "chapter2"
}


variable "db_password" {
  type = "string"
  description = "DB password"
  default = "developer"
}

variable "aws_creds_profile" {
  type = "string"
  description = "AWS profile name in which your credentials files are stored"
  default = "ore"
//  default = "de-lab"
}

variable "auth_key_name" {
  type = "string"
  description = "AWS PEM file name"
  default = "de"
}

variable "tags" {
  type = "map"
  description = "Resource tag values"
  default = {
    chapterId = "chapter-3"
    sectionId = "section-3"
  }
}