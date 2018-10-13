FROM manycoding/robotframework
RUN pip install robotframework-requests
VOLUME /robot/tests
VOLUME /robot/report
ENTRYPOINT [ "robot", "-d", "/robot/report", "/robot/tests"]
