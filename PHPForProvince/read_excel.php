<?php
	require_once './PHPExcel/Classes/PHPExcel.php';

	$filename = './uploads/province.xls'; 

	// Check prerequisites
	if (!file_exists($filename)) {
		exit("not found province.xls.\n");
	}

	$objReader = PHPExcel_IOFactory::createReaderForFile($filename);
	$objPHPExcel = $objReader->load($filename);

	$dataArray = array();
	for ($i = 0; $i < 2; $i ++) {
		$tempArray = array();
	
		$objPHPExcel->setActiveSheetIndex($i);
		$objWorksheet = $objPHPExcel->getActiveSheet();
		foreach($objWorksheet->getRowIterator() as $row){ 

			$tempArray2 = array();
			$cellIterator = $row->getCellIterator();
			$cellIterator->setIterateOnlyExistingCells(false);
			foreach($cellIterator as $cell){
				//echo $cell->getValue()."   ";
				$tempArray2[] = $cell->getValue();
			}
			$tempArray[] = $tempArray2;
			//echo "</br>";
		}
		//echo "</br>";
		$dataArray[] = $tempArray;
	}
	$provinceArray = $dataArray[0];
	$cityArray = $dataArray[1];

	// for ($i=1; $i < count($provinceArray); $i++) { 
	// 	var_dump($provinceArray[$i]);
	// 	echo "</br>";
	// }

	// for ($i=1; $i < count($cityArray); $i++) { 
	// 	var_dump($cityArray[$i]);
	// 	echo "</br>";
	// }

	$allDataArray = array();

	$provinceCounts = 0;
	$cityCounts = 0;

	for ($i=1; $i < count($provinceArray); $i++) { 

		$currentProvinceCode = $provinceArray[$i][0];
		$currentProvinceName = $provinceArray[$i][1];

		$provinceTempData = array();
		$provinceTempData["code"] = $currentProvinceCode;
		$provinceTempData["name"] = $currentProvinceName;	//存储省名

		//过滤当前该省的城市


		$currentProvinceCitys = array();
		for ($j=0; $j < count($cityArray); $j++) { 
			$currentCityCode = $cityArray[$j][0];
			$currentCityName = $cityArray[$j][1];
			$currentCityProvince = $cityArray[$j][2];

			// if ($currentCityName == "市辖区") {
			// 	$currentCityName = $currentCityProvince;
			// }

			if ($currentCityProvince == $currentProvinceName) {
				$cityCounts ++;

				$currentCity = array();
				$currentCity["code"] = $currentCityCode;
				$currentCity["name"] = $currentCityName;

				$currentProvinceCitys[] = $currentCity;
			}
		}

		$provinceTempData["citys"] = $currentProvinceCitys;

		$allDataArray[] = $provinceTempData;
		$provinceCounts ++;
	}


	echo json_encode($allDataArray);

	// echo "</br>";
	// echo "共".$provinceCounts."个省， 共".$cityCounts."个市区";
?>