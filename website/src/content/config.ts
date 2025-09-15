import { defineCollection, z } from "astro:content";

const privacyCollection = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    lastUpdated: z.date(),
  }),
});

export const collections = {
  privacy: privacyCollection,
};
