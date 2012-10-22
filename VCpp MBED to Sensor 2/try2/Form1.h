#pragma once

namespace try2 {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	using namespace System::IO::Ports;			// *** added to allow listing of COM ports
	using namespace System::Threading;          // *** added to allow access to Sleep command

	/// <summary>
	/// Summary for Form1
	/// </summary>
	public ref class Form1 : public System::Windows::Forms::Form
	{
	public:
		Form1(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~Form1()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::ComboBox^  comboBox1;
	protected: 
	private: System::Windows::Forms::Button^  initButton;
	private: System::IO::Ports::SerialPort^  serialPort1;
	private: System::ComponentModel::IContainer^  components;
	private: System::Windows::Forms::TextBox^  textBox1;
	private: System::Windows::Forms::Button^  goButton;

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>

//**********************************************************************************************************
// Added programmer variables
//**********************************************************************************************************
	private:
		int					global_error;	// *** added to create an error variable

//**********************************************************************************************************
// Added programmer constant definitions
//**********************************************************************************************************
#define		OK				 0
#define		FORMAT_ERROR	-1
//**********************************************************************************************************


#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->components = (gcnew System::ComponentModel::Container());
			this->comboBox1 = (gcnew System::Windows::Forms::ComboBox());
			this->initButton = (gcnew System::Windows::Forms::Button());
			this->serialPort1 = (gcnew System::IO::Ports::SerialPort(this->components));
			this->textBox1 = (gcnew System::Windows::Forms::TextBox());
			this->goButton = (gcnew System::Windows::Forms::Button());
			this->SuspendLayout();
			// 
			// comboBox1
			// 
			this->comboBox1->FormattingEnabled = true;
			this->comboBox1->Location = System::Drawing::Point(332, 70);
			this->comboBox1->Name = L"comboBox1";
			this->comboBox1->Size = System::Drawing::Size(121, 21);
			this->comboBox1->TabIndex = 0;
			// 
			// initButton
			// 
			this->initButton->Location = System::Drawing::Point(332, 98);
			this->initButton->Name = L"initButton";
			this->initButton->Size = System::Drawing::Size(121, 23);
			this->initButton->TabIndex = 1;
			this->initButton->Text = L"Init";
			this->initButton->UseVisualStyleBackColor = true;
			this->initButton->Click += gcnew System::EventHandler(this, &Form1::initButton_Click);
			// 
			// textBox1
			// 
			this->textBox1->Location = System::Drawing::Point(229, 242);
			this->textBox1->Multiline = true;
			this->textBox1->Name = L"textBox1";
			this->textBox1->ScrollBars = System::Windows::Forms::ScrollBars::Vertical;
			this->textBox1->Size = System::Drawing::Size(250, 157);
			this->textBox1->TabIndex = 2;
			// 
			// goButton
			// 
			this->goButton->Location = System::Drawing::Point(49, 87);
			this->goButton->Name = L"goButton";
			this->goButton->Size = System::Drawing::Size(75, 23);
			this->goButton->TabIndex = 3;
			this->goButton->Text = L"go for it";
			this->goButton->UseVisualStyleBackColor = true;
			this->goButton->Click += gcnew System::EventHandler(this, &Form1::goButton_Click);
			// 
			// Form1
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(491, 411);
			this->Controls->Add(this->goButton);
			this->Controls->Add(this->textBox1);
			this->Controls->Add(this->initButton);
			this->Controls->Add(this->comboBox1);
			this->Name = L"Form1";
			this->Text = L"Form1";
			this->Load += gcnew System::EventHandler(this, &Form1::Form1_Load);
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion

int get_reply(void) {

	String^ reply = serialPort1->ReadLine();
	textBox1->AppendText("Reply = " + reply + Environment::NewLine);
	try {
		return Convert::ToSingle(reply);
	}
	catch (FormatException^ fe) {     // string in wrong format for an integer
		MessageBox::Show("The calculations are complete",
		 				 "COM test", 
						 MessageBoxButtons::OKCancel,
						 MessageBoxIcon::Asterisk);
		global_error = FORMAT_ERROR;    // set global error code
		return -1;
	}
}


	private: System::Void Form1_Load(System::Object^  sender, System::EventArgs^  e) {
				 for each (String^ s in SerialPort::GetPortNames()) {
					comboBox1->Items->Add(s);
				}
				global_error = OK;
				Thread::Sleep(1);   // sleep thread for 1 millisecond
			 }
	private: System::Void initButton_Click(System::Object^  sender, System::EventArgs^  e) {
				//
				// set appropriate serial port properties
				//
				serialPort1->PortName = Convert::ToString(comboBox1->SelectedItem);
				serialPort1->BaudRate = 19200;		// set 19200 baud rate
				serialPort1->ReadTimeout = 10000;	// set 10 second timeout on read channel
				
				//
				// Get selected COM port and open. Catch errors and display a message box.
				// Exit the program if error is detected.
				//
				try {
					textBox1->AppendText("Selected COM port = " + Convert::ToString(comboBox1->SelectedItem) + Environment::NewLine);
					serialPort1->Open();
				} catch (...) {    // Catch all exceptions, show message and exit
					textBox1->AppendText("Cannot open selected COM port : do you want to exit?" + Environment::NewLine);
				}

				serialPort1->DiscardInBuffer();		// clear receive buffer
				serialPort1->DiscardOutBuffer();	// clear transmit buffer
				textBox1->AppendText("Opening serial port" + Environment::NewLine);
			 
			 }
private: System::Void goButton_Click(System::Object^  sender, System::EventArgs^  e) {
			String^ command = "1";
			textBox1->AppendText(command + Environment::NewLine);
			serialPort1->WriteLine(command);
			textBox1->AppendText("Reading reply" + Environment::NewLine);
			get_reply();
		 }
};
}



