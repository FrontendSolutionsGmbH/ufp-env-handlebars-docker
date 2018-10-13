FROM manycoding/robotframework:alpine
# In the RobotFramework test we make use of the requests library, making simple text-compare of generated html, no fancy selenium required here, but we need to install it to the image
RUN pip install robotframework-requests==0.4.7
# Mount the volumes, the incoming test direcory
VOLUME /robot/tests
# Mount the volumes, the outgoing report dir
VOLUME /robot/report
ENTRYPOINT [ "robot", "-d", "/robot/report", "/robot/tests"]
