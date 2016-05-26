<?php

	//加载PHPExcel以及我们的要打开的excel -- province.excel
	require_once './PHPExcel/Classes/PHPExcel.php';

	$filename = './uploads/province.xls'; 
	// Check prerequisites
	if (!file_exists($filename)) {
		exit("not found province.xls.\n");
	}

	$objReader = PHPExcel_IOFactory::createReaderForFile($filename);
	$objPHPExcel = $objReader->load($filename);




	//dataArray中存放这两个Sheet的数据，第一项是第一个Sheet中的数据，第二项是第二个Sheet中的数据
	$dataArray = array();	

	for ($i = 0; $i < 2; $i ++) {

		$tempSheetArray = array();						//暂存当前Sheet中的数据
	
		$objPHPExcel->setActiveSheetIndex($i);			//通过索引激活相应的Sheet
		$objWorksheet = $objPHPExcel->getActiveSheet();	//获取已经被激活的Sheet

		//通过迭代器来遍历当前Sheet中的数据，取出每行每列中的数据并存入数组中
		foreach($objWorksheet->getRowIterator() as $row){ 

			$tempRowArray = array();	//暂存当前Row中的数据

			$cellIterator = $row->getCellIterator();
			$cellIterator->setIterateOnlyExistingCells(false);
			foreach($cellIterator as $cell){
				echo $cell->getValue()."   ";
				$tempRowArray[] = $cell->getValue();	//将当前行中每列的数据存入tempRowArray中
			}

			$tempSheetArray[] = $tempRowArray;			//将每行的数据存入tempSheetArray中
			echo "</br>";
		}
		echo "</br>";
		$dataArray[] = $tempSheetArray;					//将每个Sheet的数据存入dataArray中
	}




	//对dataArray中的数据进行打印并
	$provinceArray = $dataArray[0];	//获取第一个sheet中的数据
	$cityArray = $dataArray[1];		//获取第二个Sheet中的数据

	//打印第一个Sheet中的数据
	for ($i=1; $i < count($provinceArray); $i++) { 
		var_dump($provinceArray[$i]);
		echo "</br>";
	}

	//打印第二个Sheet中的数据
	for ($i=1; $i < count($cityArray); $i++) { 
		var_dump($cityArray[$i]);
		echo "</br>";
	}





	//省市的计数
	$provinceCounts = 0;
	$cityCounts = 0;

	$allDataArray = array();	//存储所有的数据							

	for ($i=1; $i < count($provinceArray); $i++) {			//遍历第一个Sheet（省数据）

		$currentProvinceCode = $provinceArray[$i][0];		//获取省编码
		$currentProvinceName = $provinceArray[$i][1];		//获取省名

		$provinceTempData = array();						//用来存储省以及该省所有市的信息
		$provinceTempData["code"] = $currentProvinceCode;
		$provinceTempData["name"] = $currentProvinceName;	//存储省名

		//过滤当前该省的城市
		$currentProvinceCitys = array();					//存储当前省中所有市的信息

		//循环读取每个市的信息
		for ($j=0; $j < count($cityArray); $j++) { 

			$currentCityCode = $cityArray[$j][0];
			$currentCityName = $cityArray[$j][1];
			$currentCityProvince = $cityArray[$j][2];

			//将市的信息与省信息进行匹配
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
	//转成Json输出
	echo json_encode($allDataArray);

	echo "</br>";
	echo "共".$provinceCounts."个省， 共".$cityCounts."个市区";
?>