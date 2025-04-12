export default interface Recipe {
  id?: string;
  image: string;
  title: string;
  description: string;
  ingredients: string[];
  directions: string[];
}