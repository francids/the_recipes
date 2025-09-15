/// <reference types="astro/client" />

declare namespace App {
  interface Locals {
    lang: import("./utils/i18n").Language;
  }
}
