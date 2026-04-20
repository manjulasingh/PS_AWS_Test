# Docker File Copy & Export Example

This project demonstrates how to:

1. Copy a file from the current directory into a Docker image at build time.
2. When the container runs, copy that file **from the container to the host machine** and then exit.

> ℹ️ The copy-back to the host works using a **bind mount** (`-v`), which makes a host directory available inside the container.

***

## 3. Build the Docker Image

Run the following command from the directory containing the `Dockerfile`, `entrypoint.sh`, and the file to be copied (for example: `commands.sh`):

```bash
docker build -t copy-out-demo .
```

This will:

* Create a Docker image named `copy-out-demo`
* Copy the contents of the current directory into the image
* Configure the container to copy a file back to the host when it runs

***

## 4. Run the Container and Copy File to Host

### Linux / macOS

```bash
mkdir -p out

docker run --rm \
  -e FILE_TO_COPY="commands.sh" \
  -v "$(pwd)/out:/out" \
  copy-out-demo
```

### Windows (PowerShell)

```powershell
mkdir out -Force

docker run --rm `
  -e FILE_TO_COPY="commands.sh" `
  -v "${PWD}\out:/out" `
  copy-out-demo
```

### What happens when you run this?

* The container starts
* Copies `commands.sh` from inside the container to the host `out/` directory
* Exits immediately
* The container is automatically removed (`--rm`)

After execution, you will find the file here:

out/commands.sh

***

### Environment Variables Used

| Variable       | Description                                     |
| -------------- | ----------------------------------------------- |
| `FILE_TO_COPY` | Name of the file copied from image to host      |
| `OUT_DIR`      | Destination directory inside container (`/out`) |

***
