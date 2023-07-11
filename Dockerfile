FROM frolvlad/alpine-mono

# ENV DEBIAN_FRONTEND noninteractive

RUN apk update && apk add bash
# Run Nitrox
COPY ./scripts /software/scripts/

# Install dependencies
RUN apk update 
RUN	apk upgrade 
RUN	apk --no-cache add curl unzip wget libgdiplus

CMD \
	bin/bash software/scripts/setup-timezone.sh \
	&& bin/bash software/scripts/setup-user.sh \
	&& bin/bash software/scripts/install-nitrox.sh \
	&& bin/bash software/scripts/run-nitrox.sh