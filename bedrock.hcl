// Refer to https://docs.basis-ai.com/getting-started/writing-files/bedrock.hcl for more details.
version = "1.0"

serve {
    image = "continuumio/miniconda3:latest"
    install = [
      "apt-get update && apt-get install -y build-essential",
      "conda env create -f production.yml",
      "eval \"$(conda shell.bash hook)\" && conda activate production && pip install bdrk[model-monitoring]==0.3.0",
    ]
    script = [
        {sh = [
            "./entrypoint.sh"
        ]}
    ]

    parameters {
        WORKERS = "2"
        prometheus_multiproc_dir = "/tmp"
    }
}