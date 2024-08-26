# MODULE := Devices


setup:
	flutter pub run build_runner build

api:
	if [ ! -f "db.json" ]; then \
		echo "Arquivo db.json não encontrado. Copiando db.example.json para db.json."; \
		cp db.example.json db.json; \
	fi

	npx json-server db.json