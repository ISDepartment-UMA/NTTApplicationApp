function LimitAttach(form, file,message) {
				extArray = new Array(".jpg", ".png");
				allowSubmit = false;
				if (!file)
					return;
				while (file.indexOf("\\") != -1) {
					file = file.slice(file.indexOf("\\") + 1);
					ext = file.slice(file.indexOf(".")).toLowerCase();
					for ( var i = 0; i < extArray.length; i++) {
						if (extArray[i] == ext) {
							allowSubmit = true;
							break;
						}
					}
					console.log("allowSubmit is :"+allowSubmit);
					if (!allowSubmit) {
						alert(message);
						return false;
					}
					else{
						form.submit();
						
					}
				}
			}