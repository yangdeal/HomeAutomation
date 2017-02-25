# this is used for removing iSpy thumbs pictures

cd /volume1/Shared/97-motion-short-term
find . -name thumbs -exec rm -rf {} \;
find . -name data.xml -exec rm -rf {} \;
find . -name audio -type d -exec rm -rf {} \;

