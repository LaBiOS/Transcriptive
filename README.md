[![DOI](https://zenodo.org/badge/200312426.svg)](https://zenodo.org/badge/latestdoi/200312426)


# Transcriptive

Transcriptive is a bioinformatics analysis pipeline used for RNA sequencing data. The workflow processes raw data from FastQ inputs, aligns the reads, generates gene and transcript counts,  and performs extensive quality-control on the results. 

The pipeline is still in **alpha version** and some steps need to be performed manually through the web pages of the CPC2, CPAT, CNCI and CPPRED tools.

The pipeline was built using Docker, allowing it to run across multiple computing infrastructures in a very portable way. In addition, it is configured in a Galaxy environment with its main dependencies.

------------


## Galaxy Docker Image

The Galaxy Docker Image is an easy distributable full-fledged Galaxy installation, that can be used for testing, teaching and presenting new tools and features.

One of the main goals is to make the access to entire tool suites as easy as possible. Usually, this includes the setup of a public available web-service that needs to be maintained, or that the Tool-user needs to either setup a Galaxy Server by its own or to have Admin access to a local Galaxy server. With docker, tool developers can create their own Image with all dependencies and the user only needs to run it within docker.

The Image is based on Ubuntu 14.04 LTS and all recommended Galaxy requirements are installed. 

---

## Using passive mode FTP or SFTP

By default, FTP servers running inside of docker containers are not accessible via passive mode FTP, due to not being able to expose extra ports. To circumvent this, you can use the --net=host option to allow Docker to directly open ports on the host server:

```
docker run -d \
    --net=host \
    -v /home/user/galaxy_storage/:/export/ \
    quay.io/labios/transcriptive  
```

Note that there is no need to specifically bind individual ports (e.g., -p 80:80) if you use ```--net```.

An alternative to FTP and it's shortcomings it to use the SFTP protocol via port 22. Start your Galaxy container with a port binding to 22.

```
docker run -i -t -p 8080:80 -p 8022:22 \
    -v /home/user/galaxy_storage/:/export/ \
    quay.io/labios/transcriptive
```

And use for example Filezilla or the sftp program to transfer data:

```
sftp -v -P 8022 -o User=admin@galaxy.org localhost <<< $'put <YOUR FILE HERE>'
```

---

## Using Parent Docker

On some linux distributions, Docker-In-Docker can run into issues (such as running out of loopback interfaces). If this is an issue, you can use a 'legacy' mode that use a docker socket for the parent docker installation mounted inside the container. To engage, set the environmental variable DOCKER_PARENT

```
docker run -p 8080:80 -p 8021:21 -p 8800:8800 \
    --privileged=true -e DOCKER_PARENT=True \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/user/galaxy_storage/:/export/ \
    quay.io/labios/transcriptive
```

---

## Enabling Interactive Environments in Galaxy

Interactive Environments (IE) are sophisticated ways to extend Galaxy with powerful services, like Jupyter, in a secure and reproducible way.

For this we need to be able to launch Docker containers inside our Galaxy Docker container. At least docker 1.3 is needed on the host system.

```
docker run -d -p 8080:80 -p 8021:21 -p 8800:8800 \
    --privileged=true \
    -v /home/user/galaxy_storage/:/export/ \
    quay.io/labios/transcriptive
```

---

## Users & Passwords <a name="User" /> [[menu]](#menu)

The Galaxy Admin User has the username admin@galaxy.org and the password admin. If you want to create new users, please make sure to use the /export/ volume, otherwise all data will be removed whenever the container is restarted.

---

## Reproducibility of Your Search Results <a name="Reproducibility" /> [[menu]](#menu)

BLAST databases are updated daily and are not versioned. This is a general problem for reproducibility of search results. In Galaxy we track the program version, all settings and the input files. The underlying database can be tracked but this is usually very storage expensive. Note that the large NCBI BLAST databases exceeds 100 GB in size. To enable 100% reproducibility you can simply create your own BLAST datbase with Galaxy. Download your database as FASTA file and use the tool NCBI BLAST+ makeblastdb to convert your FASTA file to a proper BLAST database. These steps are reproducibly, with all settings and inputs.

If you want to use the precalculated BLAST databases from the NCBI FTP server you can configure your BLAST Galaxy instance to use those. Please have a look at Using large external BLAST databases.

Please understand that we cannot ship the NCBI BLAST databases by default in this Docker container, as we try to keep the image as small as possible.

---

## Using Large External BLAST Databases <a name="Blast" /> [[menu]](#menu)

You can get BLAST databases directly from the NCBI server and include them into your Galaxy docker container.

- Download your databases from ftp://ftp.ncbi.nlm.nih.gov/blast/db/. You can use the NCBI suggested perl script to automatize this step.
- Store all your BLAST databases in one directory, for example /galaxy_store/data/blast_databases/
- Start your Galaxy container with ```-v /galaxy_store/data/blast_databases/:/data/``` to have access your databases inside of your container
- Start your Galaxy container with ```-v /home/user/galaxy_storage/:/export/``` to export all config files to your host operating system
- Modify your blast*.loc files under /home/user/galaxy_storage/galaxy-central/tool-data/blast*.loc on your host, or under /export/galaxy-central/tool-data/blast*.loc from within your container.
- You need to add the paths to your blast databases. They need to look like /export/swissprot/swissprot
- Restart your Galaxy instance, for example with docker exec <container name> supervisorctl restart galaxy:
  
From now on you should see predifined BLAST databases in your Galaxy User Interface if you choose Locally installed BLAST database.

---

## Author <a name="Author" /> [[menu]](#menu)

Current development by Fabiano Menegidio (<fabiano.menegidio@biology.com.br>), David Aciole (<aciole.d@gmail.com>), Daniela Jabes (<danielajabes@umc.br>) and Luiz Nunes (<luiz.nunes@ufabc.edu.br>).

## Contributing <a name="Contributing" /> [[menu]](#menu)

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a GitHub issue, especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

## MIT License <a name="MIT" /> [[menu]](#menu)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

***The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. in no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.***

---

## Citation

If you use this tool, please cite:

---

## Bug Reports

Any bug can be filed in an issue here.

---

## Contributing

How to Contribute:

- Make sure you have a GitHub account
- Make sure you have git installed
- Fork the repository on GitHub
- Make the desired modifications - consider using a feature branch
- Open a pull request with these changes.


