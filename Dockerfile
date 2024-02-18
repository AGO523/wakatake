# ビルドステージ
FROM node:20.11.1-alpine3.18 as builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# 実行ステージ
FROM node:20.11.1-alpine3.18

WORKDIR /app

# ビルドステージからのファイルコピー
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# 静的ファイルを提供する設定が必要な場合は、ここに追加

CMD ["npm", "start"]

EXPOSE 3000
