FROM ubuntu:14.04

# Update Apt
RUN apt-get update

# Install Git, npm, and node
RUN apt-get install -y git npm nodejs

# Rename nodejs to node
RUN sudo ln -s /usr/bin/nodejs /usr/bin/node

# Create user 'kaiser'
RUN useradd -m -d /home/kaiser -c "Docker image user" kaiser
RUN chown -R kaiser /opt

# Run the rest of the commands as 'kaiser'
USER kaiser
ENV HOME /home/kaiser

# Add source
ADD . /opt/wink

# Install app deps
RUN cd /opt/wink; npm install

WORKDIR /opt/wink
CMD ["npm", "run", "build"]
