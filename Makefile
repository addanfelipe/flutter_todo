# MODULE := Devices


setup:
	flutter pub run build_runner build

api:
	npx json-server db.json