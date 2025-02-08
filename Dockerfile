# Build stage
FROM golang:1.23-alpine AS build

# Install necessary tools
RUN apk add --no-cache curl git

# Install Air for live reloading
RUN go install github.com/cosmtrek/air@latest

WORKDIR /app

# Copy go.mod and go.sum before copying the full project
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application
COPY . .

# Install templ for templ file generation
RUN go install github.com/a-h/templ/cmd/templ@latest && \
    templ generate && \
    curl -sL https://github.com/tailwindlabs/tailwindcss/releases/download/v3.4.10/tailwindcss-linux-x64 -o tailwindcss && \
    chmod +x tailwindcss && \
    ./tailwindcss -i cmd/web/styles/input.css -o cmd/web/assets/css/output.css

# Production Build
RUN go build -o main cmd/api/main.go

# Production stage
FROM alpine:3.20.1 AS prod
WORKDIR /app

# Copy built application
COPY --from=build /app/main /app/main

# Expose port
EXPOSE ${PORT}

# Default command for production
CMD ["./main"]

# Development stage
FROM build AS dev

# Install development tools
RUN apk add --no-cache inotify-tools

# Copy Air config
COPY .air.toml /app/.air.toml

# Command for live reloading
CMD ["air"]

