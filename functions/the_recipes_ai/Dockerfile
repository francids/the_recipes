FROM oven/bun:latest
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install
COPY . .
RUN bun run build
EXPOSE 3000
ENV NODE_ENV=production
ENV PORT=3000
CMD ["bun", "run", "dist/index.js"]
