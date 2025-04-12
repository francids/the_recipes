/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'firebasestorage.googleapis.com',
        pathname: '/v0/b/the-recipes-90baa.appspot.com/o/recipe-images**',
      },
    ],
  },
}

module.exports = nextConfig
